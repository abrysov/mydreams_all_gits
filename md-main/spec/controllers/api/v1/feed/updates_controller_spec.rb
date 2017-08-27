require 'rails_helper'

RSpec.describe Api::V1::Feed::UpdatesController, type: :controller do
  let(:initator) { create(:light_dreamer) }
  let(:dreamer) { create(:light_dreamer) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
  let(:json_response) { JSON.parse(response.body) }
  let(:notif_response) { json_response['updates'][0] }
  let(:schema) { "#{fixture_path}/schema/v1_updates.json" }

  describe 'GET #index' do
    context 'get notification about certificate for dream' do
      before do
        @certif_notif = create :notification_with_certificate, dreamer: dreamer
        get :index, access_token: token
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has initator' do
        expect(notif_response['initiator']['id']).to eq @certif_notif.initiator.id
      end
      it 'has certificate with dream' do
        certificate = @certif_notif.resource
        dream = certificate.certifiable
        expect(notif_response['resource']['certificate']['id']).to eq certificate.id
        expect(notif_response['resource']['certificate']['certifiable']['id']).to eq dream.id
      end
      it 'has gift_self action' do
        expect(notif_response['action']).to eq 'gift_self'
      end
    end

    context 'get notification about create dream' do
      before do
        @certif_notif = create :notification_with_dream, dreamer: dreamer
        get :index, access_token: token
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has initator' do
        expect(notif_response['initiator']['id']).to eq @certif_notif.initiator.id
      end
      it 'has resource Dream' do
        dream = @certif_notif.resource
        expect(notif_response['resource']['dream']['id']).to eq dream.id
      end
      it 'has action' do
        expect(notif_response['action']).to eq 'create_dream'
      end
    end

    context 'get notification about deleted dreamer' do
      before do
        @dreamer_notif = create :notification_with_deleted_dreamer, dreamer: dreamer
        get :index, access_token: token
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has initator' do
        expect(notif_response['initiator']['id']).to eq @dreamer_notif.initiator.id
      end
      it 'has deleted dreamer' do
        deleted_dreamer = @dreamer_notif.resource
        expect(deleted_dreamer).to be_deleted
        expect(notif_response['resource']['dreamer']['id']).to eq deleted_dreamer.id
      end
      it 'has dreamer_deleted action' do
        expect(notif_response['action']).to eq 'dreamer_deleted'
      end
    end
  end
end
