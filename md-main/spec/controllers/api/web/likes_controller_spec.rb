require 'rails_helper'

RSpec.describe Api::Web::LikesController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }

  describe 'GET #index' do
    let(:schema) { "#{fixture_path}/schema/v1_likes_like_for.json" }
    let(:dreamer) { create :light_dreamer }
    let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }

    before do
      sign_in dreamer
      like_1
      like_2
      get :index, params
    end

    context 'when success find dream and likes' do
      let(:dream) { create :dream }
      let(:like_1) { create :like, likeable: dream }
      let(:like_2) { create :like, likeable: dream }
      let(:params) { { entity_id: dream.id, entity_type: 'dream' } }

      it { expect(response.status).to eq 200 }
      it { expect(json_response['likes'].count).to eq 2 }
      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end

    context 'when show likes from private dream' do
      let(:dream) { create :dream, restriction_level: 2 }
      let(:like_1) { create :like, likeable: dream }
      let(:like_2) { create :like, likeable: dream }
      let(:params) { { entity_id: dream.id, entity_type: 'dream' } }

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end

    context 'when failed find dream' do
      let(:like_1) { create :like }
      let(:like_2) { create :like }
      let(:params) { { entity_id: 1234, entity_type: 'dream' } }

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end

    context 'when success find post and likes' do
      let(:test_post) { create :light_post }
      let(:like_1) { create :like, likeable: test_post }
      let(:like_2) { create :like, likeable: test_post }
      let(:params) { { entity_id: test_post.id, entity_type: 'post' } }

      it { expect(response.status).to eq 200 }
      it { expect(json_response['likes'].count).to eq 2 }
      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end

    context 'when show likes from private post' do
      let(:test_post) { create :light_post, restriction_level: 2 }
      let(:like_1) { create :like, likeable: test_post }
      let(:like_2) { create :like, likeable: test_post }
      let(:params) { { entity_id: test_post.id, entity_type: 'post' } }

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end
  end

  describe 'POST #create' do
    let(:dreamer) { create :dreamer }
    let(:dream) { create :dream }
    let(:schema) { "#{fixture_path}/schema/v1_dreamer_like.json" }
    before do
      sign_in dreamer
      post :create, entity_type: 'dream', entity_id: dream.id
    end

    it { expect(response.status).to eq 200 }
    it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
    it do
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['status']).to eq 'success'
    end
  end

  describe 'delete #destroy' do
    let(:like) { create :like }
    let(:dreamer) { like.dreamer }

    before do
      sign_in dreamer
      delete :destroy, id: like.likeable.id, entity_type: like.likeable.class.to_s.underscore
    end

    it { expect(response.status).to eq 200 }
    it { expect(Like.find_by(id: like.id)).to be_nil }
    it do
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['status']).to eq 'success'
    end
  end
end
