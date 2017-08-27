require 'rails_helper'

RSpec.describe Api::V1::Feed::CommentsController, type: :controller do
  let(:dreamer) { create(:light_dreamer) }
  let(:not_speaker) { create :light_dreamer }
  let(:speaker) do
    speaker = create :light_dreamer
    Relations::SendFriendRequest.call(from: dreamer, to: speaker)
    speaker
  end
  let(:schema) { "#{fixture_path}/schema/v1_post_with_comments.json" }
  let(:json_response) { JSON.parse(response.body) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
  let(:post_with_comments) { json_response['comments'] }
  let(:post_with_comment_ids) { post_with_comments.map { |post| post['id'] } }

  describe 'GET #index' do
    context 'when commented my folowees' do
      let(:not_speaker_post)     { create :post, restriction_level: 0, dreamer: not_speaker }
      let(:speaker_post)         { create :post, restriction_level: 0, dreamer: speaker }
      let(:speaker_private_post) { create :post, restriction_level: 2, dreamer: speaker }

      before do
        @speaker_comm     = create :comment, commentable: speaker_post,         dreamer: speaker
        @not_speaker_comm = create :comment, commentable: not_speaker_post,     dreamer: speaker
        @comm_of_private  = create :comment, commentable: speaker_private_post, dreamer: speaker
        get :index, access_token: token, source: 'subscriptions'
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it 'response OK' do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has post that has been commented speaker only' do
        expect(Post.count).to eq 3
        expect(post_with_comments.count).to eq 2
        expect(post_with_comment_ids).to be_include(@speaker_comm.commentable.id)
        expect(post_with_comment_ids).to be_include(@not_speaker_comm.commentable.id)
      end
      it 'has not speaker private posts' do
        expect(post_with_comment_ids).not_to be_include(@comm_of_private.commentable.id)
      end
    end

    context 'when commmented by me' do
      let(:not_speaker_post) { create :post, restriction_level: 0, dreamer: not_speaker }
      let(:speaker_post)     { create :post, restriction_level: 0, dreamer: speaker }

      before do
        @commented_by_me    = create :comment, commentable: speaker_post,     dreamer: dreamer
        @commented_by_sbscr = create :comment, commentable: not_speaker_post, dreamer: speaker
        get :index, access_token: token
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it 'response OK' do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has post that has been commented by me only' do
        expect(post_with_comments.count).to eq 1
        expect(post_with_comment_ids).to be_include(@commented_by_me.commentable.id)
        expect(post_with_comment_ids).not_to be_include(@commented_by_sbscr.commentable.id)
      end
    end

    context 'when commented NOT my folowees' do
      let(:not_speaker_post)     { create :post, restriction_level: 0, dreamer: not_speaker }
      let(:speaker_post)         { create :post, restriction_level: 0, dreamer: speaker }
      let(:speaker_private_post) { create :post, restriction_level: 2, dreamer: speaker }

      before do
        create :comment, commentable: not_speaker_post,      dreamer: not_speaker
        create :comment, commentable: speaker_post,          dreamer: not_speaker
        create :comment, commentable: speaker_private_post,  dreamer: not_speaker
        get :index, access_token: token, source: 'subscriptions'
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it 'response OK' do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has no posts' do
        expect(Post.count).to eq 3
        expect(json_response['comments'].count).to eq 0
      end
    end
  end
end
