require 'rails_helper'

RSpec.describe Api::Web::PurchasesController, type: :controller do
  describe 'GET #show' do
    let(:json_response) { JSON.parse(response.body) }
    let(:schema) { "#{fixture_path}/schema/purchases/web_purchases.json" }
    let(:dreamer) { create :light_dreamer }
    let(:account) { create :account, dreamer: dreamer }
    let(:product) { create :product_vip }
    let(:purchase) do
      create_list :purchase, 2, dreamer: account.dreamer, destination: dreamer, product: product
    end

    context 'return current dreamer' do
      before do
        purchase
        sign_in dreamer
        get :index
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(response.status).to eq 200
        expect(json_response['purchases'].count).to eq 2
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end
  end
end