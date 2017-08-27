require 'rails_helper'

RSpec.describe Api::V1::Dreamers::DreamsController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }
  let(:dream) { create :dream }
  let(:dreamer) { dream.dreamer }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
  let(:schema) { "#{fixture_path}/schema/v1_dreams.json" }
  let(:another_dream) { create :dream }

  describe 'GET #index' do
    context 'get dreams only for dreamer' do
      before do
        another_dream
        get :index, dreamer_id: dreamer.id, access_token: token
      end

      it { expect(response.status).to eq 200 }
      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['total_count']).to eq 1
      end
    end

    context 'get filtered dreams' do
      let(:fulfilled_dream) { create :fulfilled_dream, dreamer: dreamer }

      before do
        fulfilled_dream
        another_dream
        get :index, dreamer_id: dreamer.id, fulfilled: true, access_token: token
      end

      it { expect(response.status).to eq 200 }
      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(json_response['dreams'][0]['id']).to eq fulfilled_dream.id }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['total_count']).to eq 1
      end
    end

    context 'when get dreams ordered by launches count' do
      let(:dream_with_launches) { create :dream, dreamer: dreamer, launches_count: 10 }

      before do
        dream_with_launches
        get :index, dreamer_id: dreamer.id, access_token: token, launches: true
      end

      it { expect(json_response['dreams'].first['id']).to eq dream_with_launches.id }
    end
  end
end
