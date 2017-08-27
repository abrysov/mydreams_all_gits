require 'rails_helper'

RSpec.describe Api::V1::Profile::ConversationsController, type: :controller do
  describe 'GET #show' do
    let(:dreamer) { create(:dreamer) }
    let(:json) { JSON.parse(subject.body) }
    let(:schema) { "#{fixture_path}/schema/v1_profile_conversations.json" }
    let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }

    context 'dreamer conversations' do
      before do
        create(:message, receiver: dreamer)
      end

      subject { get :index, access_token: token }

      it { is_expected.to have_http_status 200 }
      it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
      it do
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
        expect(json['conversations'].count).to eq 1
      end
    end
  end
end
