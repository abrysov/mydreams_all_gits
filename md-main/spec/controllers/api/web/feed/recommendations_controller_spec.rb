require 'rails_helper'

RSpec.describe Api::Web::Feed::RecommendationsController, type: :controller do
  let(:dreamer) { create(:light_dreamer) }
  let(:not_speaker) { create :light_dreamer }
  let(:speaker) do
    speaker = create :light_dreamer
    Relations::SendFriendRequest.call(from: dreamer, to: speaker)
    speaker
  end
  let(:schema) { "#{fixture_path}/schema/v1_recommendations.json" }
  let(:json_response) { JSON.parse(response.body) }
  let(:recommendations) { json_response['recommendations'] }
  let(:recommendation_ids) { recommendations.map { |post| post['id'] } }

  describe 'GET #index' do
    context 'when liked my folowees' do
      let(:not_speaker_post)     { create :post, restriction_level: 0, dreamer: not_speaker }
      let(:speaker_post)         { create :post, restriction_level: 0, dreamer: speaker }
      let(:private_speaker_post) { create :post, restriction_level: 2, dreamer: speaker }

      before do
        sign_in dreamer
        @speaker_like     = create :like, likeable: speaker_post,         dreamer: speaker
        @not_speaker_like = create :like, likeable: not_speaker_post,     dreamer: not_speaker
        @like_of_private  = create :like, likeable: private_speaker_post, dreamer: speaker
        get :index, source: 'subscriptions'
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it 'response OK' do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has post that has been liked speaker only' do
        expect(recommendations.count).to eq 1
        expect(recommendation_ids).to be_include(@speaker_like.likeable.id)
        expect(recommendation_ids).not_to be_include(@not_speaker_like.likeable.id)
      end
      it 'has not speaker private posts' do
        expect(recommendation_ids).not_to be_include(@like_of_private.likeable.id)
      end
    end

    context 'when liked by me' do
      let(:not_speaker_post) { create :post, restriction_level: 0, dreamer: not_speaker }
      let(:speaker_post)     { create :post, restriction_level: 0, dreamer: speaker }

      before do
        sign_in dreamer
        @like_by_me      = create :like, likeable: not_speaker_post, dreamer: dreamer
        @like_by_speaker = create :like, likeable: speaker_post,     dreamer: speaker
        get :index
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it 'response OK' do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has post that has been liked by me only' do
        expect(recommendations.count).to eq 1
        expect(recommendation_ids).to be_include(@like_by_me.likeable.id)
        expect(recommendation_ids).not_to be_include(@like_by_speaker.likeable.id)
      end
    end

    context 'when liked NOT my folowees' do
      let(:not_speaker_post)     { create :post, restriction_level: 0, dreamer: not_speaker }
      let(:speaker_post)         { create :post, restriction_level: 0, dreamer: speaker }
      let(:private_speaker_post) { create :post, restriction_level: 2, dreamer: speaker }

      before do
        sign_in dreamer
        create :like, likeable: not_speaker_post,     dreamer: not_speaker
        create :like, likeable: not_speaker_post,     dreamer: not_speaker
        create :like, likeable: private_speaker_post, dreamer: not_speaker
        get :index, source: 'subscriptions'
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it 'response OK' do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has no posts' do
        expect(json_response['recommendations'].count).to eq 0
      end
    end
  end
end
