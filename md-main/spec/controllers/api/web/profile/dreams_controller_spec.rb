require 'rails_helper'

RSpec.describe Api::Web::Profile::DreamsController, type: :controller do
  let(:dream) { create :dream }
  let(:dreamer) { dream.dreamer }
  let(:another_dream) { create :dream }

  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
  let(:json_response) { JSON.parse(response.body) }
  let(:schema) { "#{fixture_path}/schema/v1_dreams.json" }

  describe 'GET #index' do
    context 'get dreams only for dreamer' do
      before do
        sign_in dreamer
        another_dream
        get :index, access_token: token
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
        sign_in dreamer
        fulfilled_dream
        another_dream
        get :index, fulfilled: true, access_token: token
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
        sign_in dreamer
        dream_with_launches
        get :index, launches: true
      end

      it { expect(json_response['dreams'].first['id']).to eq dream_with_launches.id }
    end
  end
end
