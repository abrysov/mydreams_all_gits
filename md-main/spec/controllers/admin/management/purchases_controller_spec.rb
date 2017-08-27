require 'rails_helper'

RSpec.describe Admin::Management::PurchasesController, type: :controller do
  describe 'true way' do
    let(:dreamer) { create :dreamer, :project_dreamer, role: :admin }
    let(:account) { create :account, dreamer: dreamer }
    let(:product) { create :product_vip }
    let(:purchase) do
      create :purchase, dreamer: account.dreamer, destination: dreamer, product: product
    end

    context 'purchase list' do
      before do
        purchase
        sign_in dreamer
        get :index
      end

      it do
        is_expected.to respond_with :ok
        is_expected.to render_with_layout 'admin/management'
        is_expected.to render_template :index
      end
    end

    context 'show purchase' do
      before do
        sign_in dreamer
        get :show, id: purchase.id
      end

      it do
        is_expected.to respond_with :ok
        is_expected.to render_with_layout 'admin/management'
        is_expected.to render_template :show
      end
    end
  end
end
