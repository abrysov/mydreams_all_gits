require 'rails_helper'

RSpec.describe Api::Web::ProfilesController, type: :controller do
  describe 'PUT update' do
    let(:json_response) { JSON.parse(response.body) }

    context 'when success update' do
      let(:dreamer) { create :dreamer }
      let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
      let(:schema) { "#{fixture_path}/schema/v1_profile_create.json" }
      let(:avatar_base_64) do
        file = File.open('spec/fixtures/avatar.jpg', 'rb').read
        "data:image/jpeg;base64,#{Base64.encode64(file)}"
      end
      let(:dream_city) { create :dream_city }
      let(:dream_country) { create :dream_country }
      let(:attr) do
        {
          access_token: token,
          first_name: 'test firstname',
          last_name: 'test last_name',
          gender: 'female',
          birthday: 60.years.ago,
          avatar: avatar_base_64,
          city_id: dream_city.id,
          country_id: dream_country.id,
          status: 'test status'
        }
      end

      before do
        sign_in dreamer
        put :update, attr
      end
      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
      it do
        dreamer.reload
        expect(dreamer.first_name).to eq 'test firstname'
        expect(dreamer.last_name).to eq 'test last_name'
        expect(dreamer.gender).to eq 'female'
        expect(dreamer.birthday).not_to be_nil
        expect(dreamer.avatar).not_to be_nil
        expect(dreamer.dream_city).to eq dream_city
        expect(dreamer.dream_country).to eq dream_country
        expect(dreamer.status).to eq 'test status'
      end
    end

    context 'when failed update' do
      let(:dreamer) { create :dreamer }
      let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
      subject { put :update, attr }

      let(:attr) do
        {
          access_token: token,
          first_name: ''
        }
      end

      before do
        sign_in dreamer
        put :update, attr
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

  describe 'DELETE/POST delete/restore profile' do
    let(:dreamer) { create :dreamer }
    let(:json_response) { JSON.parse(response.body) }
    before { sign_in dreamer }

    context 'delete profile' do
      before { delete :destroy }

      it { expect(dreamer.reload).to be_deleted }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('dreamer.profile_deleted')
      end
    end

    context 'restore profile' do
      before do
        dreamer.mark_deleted
        post :restore
      end

      it { expect(dreamer.reload).not_to be_deleted }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('dreamer.profile_restored')
      end
    end
  end
end
