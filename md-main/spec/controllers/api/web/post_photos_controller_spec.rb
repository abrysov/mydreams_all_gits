require 'rails_helper'

RSpec.describe Api::Web::PostPhotosController, type: :controller do
  let(:dreamer) { create(:light_dreamer) }
  let(:json_response) { JSON.parse(response.body) }
  let(:test_post) { create :post }
  let(:photo_base_64) do
    file = File.open('spec/fixtures/avatar.jpg', 'rb').read
    "data:image/jpeg;base64,#{Base64.encode64(file)}"
  end
  let(:schema) { "#{fixture_path}/schema/v1_post_photo_create.json" }

  describe 'POST #create' do
    context 'when success create' do
      let(:params) do
        { photo: photo_base_64, post_id: test_post.id }
      end

      before do
        sign_in dreamer
        post :create, params
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
    end

    context 'when failed create' do
      let(:params) do
        { post_id: test_post.id }
      end

      before do
        sign_in dreamer
        post :create, params
      end

      it { expect(response.response_code).to eq 422 }
      it do
        expect(json_response['meta']['code']).to eq 422
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['errors']).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:post) { create :post, dreamer: dreamer }
    let(:post_photo_to_destroy) do
      PostPhoto.create(post: post, photo: photo_base_64, dreamer: dreamer)
    end

    before do
      sign_in dreamer
      delete :destroy, id: post_photo_to_destroy.id
      post.reload
    end

    it { expect(PostPhoto.find_by(id: post_photo_to_destroy.id)).to be_nil }
    it do
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['status']).to eq 'success'
      expect(json_response['meta']['message']).to eq I18n.t('api.success.destroy')
    end
  end
end
