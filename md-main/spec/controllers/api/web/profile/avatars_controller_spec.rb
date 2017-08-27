require 'rails_helper'

RSpec.describe Api::Web::Profile::AvatarsController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }

  describe 'POST create' do
    let(:schema) { "#{fixture_path}/schema/v1_dreamer_avatar.json" }
    let(:dreamer) { create :light_dreamer }
    let(:base64avatar) { Base64.encode64(File.open('spec/fixtures/avatar.jpg', 'rb').read) }

    before do
      sign_in dreamer
      post :create, avatar_params
      dreamer.reload
    end

    context 'base64 uploaded' do
      let(:avatar_params) do
        {
          id: dreamer.id,
          file: "data:image/jpeg;base64,#{base64avatar}",
          cropped_file: "data:image/jpeg;base64,#{base64avatar}",
          crop: { x: 100, y: 100, width: 400, height: 400 }
        }
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.v1.profile.avatar.uploaded')
      end
      it do
        expect(dreamer.avatar.url).not_to be_nil
        expect(dreamer.crop_meta[:avatar]).not_to be_nil
        expect(dreamer.current_avatar_id).not_to eq 0
        expect(dreamer.avatars.find_by(id: dreamer.current_avatar_id).crop_meta).not_to be_nil
      end
    end

    context 'fixtures file uploaded' do
      let(:avatar_params) do
        {
          file: fixture_file_upload('avatar.jpg', 'image/jpg'),
          cropped_file: fixture_file_upload('avatar.jpg', 'image/jpg'),
          crop: { x: 100, y: 100, width: 400, height: 400 },
          id: dreamer.id
        }
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.v1.profile.avatar.uploaded')
      end
      it { dreamer.avatars.all.count == 1 }
      it do
        expect(dreamer.avatar.url).not_to be_nil
        expect(dreamer.crop_meta[:avatar]).not_to be_empty
        expect(dreamer.current_avatar_id).not_to eq 0
        expect(dreamer.avatars.find_by(id: dreamer.current_avatar_id).crop_meta).not_to be_nil
      end
    end

    context 'invalid file' do
      let(:avatar_params) do
        {
          file: "data:image/jpeg;base64,#{base64avatar}",
          cropped: "data:image/jpeg;base64,#{base64avatar}",
          crop: { x: 100, y: 100, width: 400, height: 400 },
          id: dreamer.id
        }
      end

      it { expect(dreamer.avatar.url).to be_nil }
      it { expect(response.response_code).to eq 422 }
      it do
        expect(json_response['meta']['code']).to eq 422
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response).not_to have_key 'avatar'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when destroy current avatar' do
      let(:dreamer) { create :dreamer, :with_avatar }
      let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }

      before do
        sign_in dreamer
        @ava = Avatar.create(dreamer: dreamer, photo: FactoryHelpers.uploaded_fixture_image,
                             crop_meta: { x: 1 })

        dreamer.current_avatar = @ava
        dreamer.current_avatar_id = @ava.id
        dreamer.save

        delete :destroy, id: dreamer.current_avatar.id, access_token: token, format: :json
        dreamer.reload
      end

      it { expect(Avatar.find_by(id: @ava.id)).to be_nil }
      it { expect(dreamer.current_avatar_id).to eq 0 }
      it { expect(dreamer.avatar.present?).to eq false }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.destroy')
      end
    end

    context 'when destroy other avatars' do
      let(:dreamer) { create :light_dreamer }
      let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
      let(:avatar) { create :avatar, dreamer: dreamer }

      before do
        sign_in dreamer
        delete :destroy, id: avatar.id, format: :json
      end

      it { expect(Avatar.find_by(id: avatar.id)).to be_nil }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.destroy')
      end
    end
  end
end
