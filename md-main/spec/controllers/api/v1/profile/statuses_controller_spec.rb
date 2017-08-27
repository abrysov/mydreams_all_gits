require 'rails_helper'

RSpec.describe Api::V1::Profile::StatusesController, type: :controller do
  let(:json_response) { JSON.parse(subject.body) }

  describe 'GET show' do
    let(:dreamer) { create :dreamer }
    let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
    let(:schema) { "#{fixture_path}/schema/v1_dreamer_status.json" }

    context 'unauthorized' do
      subject { get :show }

      it { expect(subject.status).to eq 401 }
      it { expect(json_response['meta']['code']).to eq 401 }
      it { expect(json_response['meta']['status']).to eq 'fail' }
    end

    context 'dreamer' do
      let(:messages) do
        {
          friendship: create(:friend_request, receiver: dreamer),
          message: create(:message, receiver: dreamer)
        }
      end

      before { messages }
      subject { get :show, access_token: token }

      it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
      it { expect(subject.status).to eq 200 }
      it do
        expect(json_response['dreamer']['id']).to eq(dreamer.id)
        expect(json_response['dreamer']['coins_count']).to eq(dreamer.account.amount.to_i)
        expect(json_response['dreamer']['friend_requests_count']).to eq(1)
        expect(json_response['dreamer']['messages_count']).to eq(1)
        expect(json_response['dreamer']['notifications_count']).to eq(0)
      end
    end
  end
end
