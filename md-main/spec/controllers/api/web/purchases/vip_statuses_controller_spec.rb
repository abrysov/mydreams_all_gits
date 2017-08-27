require 'rails_helper'

RSpec.describe Api::Web::Purchases::VipStatusesController, type: :controller do
  describe 'true way' do
    let(:schema) { "#{fixture_path}/schema/purchases/web_vip_status.json" }
    let(:dreamer) { create :light_dreamer }
    let(:destination) { create :light_dreamer }
    let(:account) { create :account, dreamer: dreamer, amount: 1000 }
    let(:product) { create :product_vip }
    let(:json) { JSON.parse(response.body) }

    context 'purchase new' do
      before do
        account
        sign_in dreamer

        post :create, product_id: product.id, destination_id: destination.id, comment: 'hello'
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(response.content_type).to eq 'application/json' }
      it do
        expect(dreamer.account.amount).to eq 100
        expect(destination.reload.is_vip).to eq true
      end
      it do
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
      end
      it do
        purchase = dreamer.purchases.last
        expect(purchase.dreamer).to eq dreamer
        expect(purchase.destination_dreamer).to eq destination
        expect(purchase.destination).to eq destination
        expect(purchase.complete?).to eq true
      end
    end

    context 'continue purchasing' do
      let(:purchase) { create :purchase, dreamer: dreamer, destination: dreamer, product: product }
      before do
        account
        sign_in dreamer

        post :update, id: purchase.id
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(dreamer.reload.is_vip).to eq true }
      it do
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
      end
    end

    context 'unauthorized user' do
      before { post :create }

      it { expect(response.status).to eq 403 }
      it { expect(response.content_type).to eq 'application/json' }
    end
  end
end
