require 'rails_helper'

RSpec.describe Api::V1::FeedsController, type: :controller do
  let(:dreamer) { create(:light_dreamer) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
  let(:json_response) { JSON.parse(response.body) }
  let(:schema) { "#{fixture_path}/schema/v1_feeds.json" }
  let(:not_speaker) { create :light_dreamer }
  let(:speaker) do
    speaker = create :light_dreamer
    Relations::SendFriendRequest.call(from: dreamer, to: speaker)
    speaker
  end

  describe 'GET #show' do
    context 'get feeds (posts from who Im folowing and mine)' do
      let(:post_ids) { json_response['feeds'].map { |post| post['id'] } }

      before do
        create :post, restriction_level: 0, dreamer: not_speaker
        @dreamer_post         = create :post, restriction_level: 0, dreamer: dreamer
        @speaker_post         = create :post, restriction_level: 0, dreamer: speaker
        @speaker_post_private = create :post, restriction_level: 2, dreamer: speaker
        get :show, access_token: token
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has mine post and post from speaker only' do
        expect(json_response['feeds'].count).to eq 2
        expect(post_ids).to be_include(@speaker_post.id)
        expect(post_ids).to be_include(@dreamer_post.id)
      end
      it 'has not have speaker private posts' do
        expect(post_ids).not_to be_include(@speaker_post_private.id)
      end
    end
  end
end
