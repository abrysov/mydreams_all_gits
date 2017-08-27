require 'rails_helper'

RSpec.describe Api::V1::Payments::GatewaysController, type: :controller do
  describe 'true way' do
    let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: account.dreamer.id).token }
    let(:dreamer) { create :light_dreamer }
    let(:account) { create :account, dreamer: dreamer, amount: 0 }
    let(:receipt_data) { File.open("#{fixture_path}/appstore_receipt.txt", 'rb').read }
    let(:json_response) { JSON.parse(response.body) }
    let(:product) { create :inapp_appstore }

    context 'sandbox receipt' do
      before do
        product
        post :create, access_token: token, receipt_data: receipt_data, gateway: :appstore
      end

      it 'meta data' do
        expect(response.status).to eq 200

        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'inapp purchase receipt' do
        expect(json_response['receipt']['status']).to eq 0
        expect(json_response['receipt']['receipt']).not_to be_nil
        expect(json_response['receipt']['latest_receipt_info']).not_to be_nil
        expect(json_response['receipt']['latest_receipt']).not_to be_nil
        expect(json_response['receipt']['environment']).to eq 'Sandbox'
      end
      it { expect(dreamer.account.amount).to eq 1000 }
    end
  end
end
