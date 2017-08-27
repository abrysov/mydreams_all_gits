require 'rails_helper'

RSpec.describe Api::Web::PostsController, type: :controller do
  let(:dreamer) { create(:light_dreamer) }
  let(:json_response) { JSON.parse(response.body) }
  let(:schema) { "#{fixture_path}/schema/v1_post_show.json" }

  describe 'GET #show' do
    context 'when post show all and success' do
      let(:post) { create :post, restriction_level: 0 }

      before do
        sign_in dreamer
        get :show, id: post.id
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
    end

    context 'when post show only to friend and success' do
      let(:post) { create :post, restriction_level: 1 }

      before do
        Relations::SendFriendRequest.call(from: post.dreamer, to: dreamer)
        Relations::AcceptFriendRequest.call(post.dreamer, dreamer)
        sign_in dreamer
        get :show, id: post.id
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
    end

    context 'when post show only to friend and fail' do
      let(:post) { create :post, restriction_level: 1 }

      before do
        sign_in dreamer
        get :show, id: post.id
      end

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end

    context 'when post has private access and success' do
      let(:private_post) { create :post, restriction_level: 2 }
      before do
        sign_in private_post.dreamer
        get :show, id: private_post.id
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
    end

    context 'when post has privat access and fail' do
      let(:private_post) { create :post, restriction_level: 2 }
      before do
        sign_in dreamer
        get :show, id: private_post.id
      end

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end

    context 'when failed search post' do
      let(:post) { create :post }
      before do
        sign_in dreamer
        get :show, id: 123
      end

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end

    context 'when show deleted post' do
      let(:post) { create :post, deleted_at: Time.now }

      before do
        sign_in dreamer
        get :show, id: post.id
      end

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end
  end

  describe 'PUT #update' do
    before do
      sign_in dreamer
      put :update, attr
      post.reload
    end
    let(:post) { create :light_post, dreamer: dreamer }

    context 'when success update' do
      let(:attr) do
        {
          id: post.id, content: 'updated_content', restriction_level: 2
        }
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
      it { expect(post.content).to eq 'updated_content' }
      it { expect(post.restriction_level).to eq 2 }
    end

    context 'when success update with photo' do
      let(:post_photo_1) { create :post_photo, dreamer: dreamer }
      let(:post_photo_2) { create :post_photo, dreamer: dreamer }

      let(:attr) do
        {
          id: post.id, content: 'updated_content', restriction_level: 2,
          post_photos_ids: [post_photo_1.id, post_photo_2.id]
        }
      end

      it { expect(post.photos).to include(post_photo_1, post_photo_2) }
    end

    context 'when success update with photo multiple times' do
      let(:post) { create :light_post, dreamer: dreamer }
      let(:post_photo_1) { create :post_photo, dreamer: dreamer }
      let(:post_photo_2) { create :post_photo, dreamer: dreamer }

      let(:attr) do
        {
          id: post.id, content: 'updated_content', restriction_level: 2,
          post_photos_ids: [post_photo_1.id, post_photo_2.id]
        }
      end

      before do
        put :update, attr
        post.reload
      end

      it { expect(post.photos).to include(post_photo_1, post_photo_2) }
      it { expect(PostPhoto.all.count).to eq 2 }
    end

    context 'when success update with photo another dreamer' do
      let(:another_dreamer) { create :dreamer }
      let(:post_photo_1) { create :post_photo, dreamer: another_dreamer }
      let(:post_photo_2) { create :post_photo, dreamer: another_dreamer }

      let(:attr) do
        {
          id: post.id, content: 'updated_content', restriction_level: 2,
          post_photos_ids: [post_photo_1.id, post_photo_2.id]
        }
      end

      it { expect(post.photos).not_to include(post_photo_1, post_photo_2) }
    end

    context 'when failed find post' do
      let(:attr) { { id: 123, content: 'test' } }

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end
  end

  describe 'POST #create' do
    before do
      sign_in dreamer
      post :create, attr
    end

    context 'when success create' do
      let(:attr) do
        {
          content: 'test content',
          restriction_level: 1
        }
      end
      let(:expected_post) { Post.last }

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.create')
      end
      it { expect(expected_post.dreamer).to eq dreamer }
      it { expect(expected_post.content).to eq 'test content' }
      it { expect(expected_post.restriction_level).to eq 1 }
    end

    context 'when success create with photos' do
      let(:post_photo_1) { create :post_photo, dreamer: dreamer }
      let(:post_photo_2) { create :post_photo, dreamer: dreamer }

      let(:attr) do
        {
          content: 'test content', restriction_level: 1,
          post_photos_ids: [post_photo_1.id, post_photo_2.id]
        }
      end

      it do
        expect(Post.find(json_response['post']['id']).photos).to include(post_photo_1, post_photo_2)
      end
    end

    context 'when success create with photo another dreamer' do
      let(:another_dreamer) { create :dreamer }
      let(:post_photo_1) { create :post_photo, dreamer: another_dreamer }

      let(:attr) do
        {
          content: 'test content', restriction_level: 1,
          post_photos_ids: [post_photo_1.id]
        }
      end

      it do
        expect(Post.find(json_response['post']['id']).photos).not_to include(post_photo_1)
      end
    end

    context 'when failed create' do
      let(:attr) do
        {
          restriction_level: 1
        }
      end

      it { expect(response.response_code).to eq 422 }
      it do
        expect(json_response['meta']['code']).to eq 422
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.unprocessable_entity')
        expect(json_response['meta']['errors']).not_to be_empty
      end
    end
  end

  describe 'search for posts' do
    let!(:post_public) { create :post, restriction_level: 0, title: '123' }
    let!(:post_friend) { create :post, restriction_level: 1, title: '123' }
    let!(:post_private) { create :post, restriction_level: 2, title: '123' }
    let(:schema) { "#{fixture_path}/schema/v1_posts.json" }

    before { get :index, q: '123' }

    it { expect(json_response['posts'].count).to eq(1) }
    it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
    it do
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['status']).to eq 'success'
      expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
    end
  end
end
