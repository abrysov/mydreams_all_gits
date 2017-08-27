require 'rails_helper'

RSpec.describe Api::Web::Profile::PhotosController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }
  let(:dreamer) { create(:light_dreamer) }
  let(:photo) { create(:photo, dreamer: dreamer) }

  describe 'Dreamer photo' do
    let(:schema) { "#{fixture_path}/schema/v1_dreamer_photos.json" }

    before do
      photo
      sign_in dreamer
      get :index
    end

    it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
    it do
      expect(json_response['photos'].first['id']).to eq photo.id
      expect(json_response['meta']['status']).to eq 'success'
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['total_count']).to eq 1
    end
  end

  describe 'POST #create' do
    let(:schema) { "#{fixture_path}/schema/v1_dreamer_photo.json" }
    before { sign_in dreamer }

    context 'when success create' do
      let(:params) do
        { file: fixture_file_upload('avatar.jpg', 'image/jpg'),
          caption: 'test' }
      end

      before { post :create, params }

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it { expect(Photo.find_by(id: json_response['photo']['id'])).to be_present }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.create')
      end
    end

    context 'when failed create' do
      let(:params) do
        {}
      end

      before { post :create, params }

      it { expect(response.response_code).to eq 422 }
      it do
        expect(json_response['meta']['code']).to eq 422
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['errors']).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:photo) { create :photo, dreamer: dreamer }

    before do
      sign_in dreamer
      delete :destroy, id: photo.id
    end

    it { expect(PostPhoto.find_by(id: photo.id)).to be_nil }
    it do
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['status']).to eq 'success'
      expect(json_response['meta']['message']).to eq I18n.t('api.success.destroy')
    end
  end
end
