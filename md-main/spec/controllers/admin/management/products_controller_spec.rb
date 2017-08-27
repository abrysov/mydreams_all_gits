require 'rails_helper'

RSpec.describe Admin::Management::ProductsController, type: :controller do
  describe 'true way' do
    let(:dreamer) { create :dreamer, :project_dreamer, role: :admin }
    let(:product) { create :gold_certificate }

    context 'products list' do
      before do
        product
        sign_in dreamer
        get :index
      end

      it do
        is_expected.to respond_with :ok
        is_expected.to render_with_layout 'admin/management'
        is_expected.to render_template :index
      end
    end

    context 'product new form' do
      before do
        sign_in dreamer
        get :new
      end

      it do
        is_expected.to respond_with :ok
        is_expected.to render_with_layout 'admin/management'
        is_expected.to render_template :new
      end
    end

    context 'create new product' do
      let(:request_params) do
        {
          name: 'Ultimate certificate',
          product_type: 'cert',
          cost: 123,
          properties: [
            { key: 'certificate_name', value: 'ultimate' },
            { key: 'certificate_launches', value: 100 }
          ]
        }
      end

      before do
        sign_in dreamer
        post :create, request_params
      end

      it do
        product = Product.preload(:properties).last

        expect(product.name).to eq request_params[:name]
        expect(product.product_type).to eq request_params[:product_type]
        expect(product.cost).to eq request_params[:cost]

        expect(product.properties.size).to eq 2
      end
      it { expect ManagementLog.where(admin_id: dreamer.id, action: 'create') }
    end

    context 'destroy product' do
      before do
        sign_in dreamer
        post :destroy, id: product.id
      end

      it { expect(response).to be_redirect }
      it { expect(product.reload.locked?).to eq true }
      it 'log created' do
        expect(
          ManagementLog.where(logable: product,
                              admin_id: dreamer.id,
                              action: 'lock')
        )
      end
    end

    context 'update product to vip' do
      let(:request_params) do
        {
          id: product.id,
          name: 'Ultimate vip',
          product_type: 'vip',
          cost: 123,
          properties: [
            { key: 'certificate_name', value: 'ultimate' },
            { key: 'certificate_launches', value: 100 }
          ]
        }
      end

      before do
        sign_in dreamer
        post :update, request_params
      end

      it { expect(product.reload.locked?).to eq true }
      it do
        product = Product.last
        expect(product.properties.size).to eq 3
        expect(product.product_type).to eq request_params[:product_type]
        expect(product.cost).to eq request_params[:cost]
        expect(product.name).to eq request_params[:name]
      end
      it 'previous id and new id' do
        new_product = Product.last
        previous_id = new_product.properties.find_by!(key: 'previous_id').value.to_i
        new_id = product.properties.find_by!(key: 'new_id').value.to_i

        expect(product.id).to eq previous_id
        expect(new_product.id).to eq new_id
      end
      it 'log created' do
        expect(
          ManagementLog.where(logable: product,
                              admin_id: dreamer.id,
                              action: 'update')
        )
      end
    end
  end
end
