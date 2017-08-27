require 'rails_helper'

RSpec.describe Api::Web::ProductsController, type: :controller do
  describe 'GET #show' do
    let(:json_response) { JSON.parse(response.body) }
    let(:cert) { create_list :gold_certificate, 2 }
    let(:vip_status) { create :product_vip }
    let(:gateway_rate) { create :special_rate }
    let(:dreamer) { create :light_dreamer }
    let(:schema) { "#{fixture_path}/schema/purchases/web_products.json" }

    context 'return current dreamer' do
      before do
        cert
        vip_status
        gateway_rate
        sign_in dreamer
        get :index
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(response.status).to eq 200
        expect(json_response['products'].count).to eq 3
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end

    context 'only certificates' do
      before do
        cert
        vip_status
        gateway_rate
        sign_in dreamer
        get :index, certificates: true
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(response.status).to eq 200
        expect(json_response['products'].count).to eq 2
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end

    context 'only vip' do
      before do
        cert
        vip_status
        gateway_rate
        sign_in dreamer
        get :index, vip_statuses: true
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(response.status).to eq 200
        expect(json_response['products'].count).to eq 1
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end

    context 'only special' do
      before do
        cert
        vip_status
        gateway_rate
        sign_in dreamer
        get :index, special: true
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(response.status).to eq 200
        expect(json_response['products'].count).to eq 1
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end

    context 'unauthorized user' do
      before { get :index }

      it { expect(response.status).to eq 403 }
      it { expect(response.content_type).to eq 'application/json' }
    end
  end
end
