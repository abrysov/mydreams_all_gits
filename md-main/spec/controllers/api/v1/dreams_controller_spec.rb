require 'rails_helper'

RSpec.describe Api::V1::DreamsController, type: :controller do
  let(:dreamer) { create(:light_dreamer) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
  let(:json_response) { JSON.parse(response.body) }
  let(:schema) { "#{fixture_path}/schema/v1_dream.json" }
  let(:schema_dreams) { "#{fixture_path}/schema/v1_dreams.json" }

  describe 'GET #index' do
    let(:dreams) { create_list(:dream, 4) }

    context 'show dreams ' do
      let(:request_params) do
        {
          access_token: token,
          per: dreams.count,
          page: 1
        }
      end

      before { get :index, request_params }

      it do
        expect(JSON::Validator.validate!(schema_dreams, response.body, strict: true)).to be true
      end
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['per']).to eq request_params[:per]
        expect(json_response['meta']['page']).to eq request_params[:page]
        expect(json_response['meta']['total_count']).to eq dreams.count
        expect(json_response['dreams'].count).to eq request_params[:per]
      end
    end

    context 'deleted dreamer' do
      let(:deleted_dreamer) { create(:light_dreamer) }
      let(:dreams) { create(:dream, dreamer: deleted_dreamer) }
      let(:request_params) do
        {
          access_token: token,
          from: dreams.id,
          per: 1
        }
      end
      context 'deleted_at' do
        before do
          deleted_dreamer.update!(deleted_at: 5.minutes.ago)
          get :index, request_params
        end

        it { expect(json_response['dreams'].count).to eq 0 }
      end
      context 'normal dreamer' do
        before do
          deleted_dreamer.update!(deleted_at: nil)
          get :index, request_params
        end

        it { expect(json_response['dreams'].count).to eq 1 }
      end
    end

    context 'when get dreams ordered by launches count' do
      let(:dream_with_launches) { create :dream, launches_count: 10 }

      before do
        dream_with_launches
        get :index, access_token: token, launches: true
      end

      it { expect(json_response['dreams'].first['id']).to eq dream_with_launches.id }
    end
  end

  describe 'create' do
    context 'new dreams' do
      let(:request_params) { attributes_for(:dream) }

      before do
        request_params['access_token'] = token
        request_params['photo'] = fixture_file_upload('avatar.jpg', 'image/jpg')
        request_params['photo_crop'] = { x: 100, y: 100, width: 400, height: 400 }
        post :create, request_params
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.dream_create')
      end
      it do
        dream = Dream.find_by id: json_response['dream']['id']

        expect(dream.photo_crop).not_to be_nil
        expect(json_response['dream']['title']).to eq dream.title
      end
    end

    context 'failed' do
      let(:request_params) { attributes_for(:dream) }
      before do
        request_params.delete(:title)
        post :create, request_params.merge(access_token: token)
      end

      it do
        expect(json_response['meta']['code']).to eq 400
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.unprocessable_entity')
      end
    end
  end

  describe 'show' do
    context 'when dream show all and success' do
      let(:dream) { create :dream, restriction_level: 0 }
      before { get :show, access_token: token, id: dream.id }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
    end

    context 'when dream show only to friend and success' do
      let(:dream) { create :dream, restriction_level: 1 }

      before do
        Relations::SendFriendRequest.call(from: dream.dreamer, to: dreamer)
        Relations::AcceptFriendRequest.call(dream.dreamer, dreamer)
      end
      before { get :show, access_token: token, id: dream.id }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
    end

    context 'when dream show only to friend and fail' do
      let(:dream) { create :dream, restriction_level: 1 }
      before { get :show, access_token: token, id: dream.id }

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end

    context 'when dream has private access and success' do
      let(:private_dream) { create :dream, restriction_level: 2 }
      let(:private_token) do
        Doorkeeper::AccessToken.create!(resource_owner_id: private_dream.dreamer.id).token
      end
      before { get :show, access_token: private_token, id: private_dream.id }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
    end

    context 'when dream has privat access and fail' do
      let(:private_dream) { create :dream, restriction_level: 2 }
      before { get :show, access_token: token, id: private_dream.id }

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end

    context 'when failed search dream' do
      let(:dream) { create :dream }
      before { get :show, access_token: token, id: 123 }

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end

    context 'when show deleted dreams' do
      let(:dream) { create :dream, deleted_at: Time.now }

      before { get :show, id: dream.id, access_token: token }

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end
  end

  describe 'update' do
    context 'when success update' do
      let(:dream) { create :dream, dreamer: dreamer }
      let(:attributes) do
        {
          id: dream.id,
          access_token: token,
          title: 'updated title',
          photo: fixture_file_upload('avatar.jpg', 'image/jpg'),
          photo_crop: { x: 100, y: 100, width: 400, height: 400 }
        }
      end

      before { put :update, attributes }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
      it { expect(dream.reload.photo_crop).not_to be_nil }
      it { expect(dream.reload.title).to eq 'updated title' }
    end

    context 'when failed update' do
      let(:dream) { create :dream, dreamer: dreamer }
      let(:attr) do
        {
          id: dream.id,
          access_token: token,
          title: ''
        }
      end

      before { put :update, attr }

      it { expect(response.response_code).to eq 422 }
      it do
        expect(json_response['meta']['code']).to eq 422
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.unprocessable_entity')
        expect(json_response['meta']['errors']).not_to be_empty
      end
    end
  end

  describe 'destroy' do
    let(:dream) { create :dream, dreamer: dreamer }
    before { delete :destroy, id: dream.id, access_token: token }

    it { expect(dream.reload.deleted?).to eq true }
    it do
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['status']).to eq 'success'
      expect(json_response['meta']['message']).to eq I18n.t('api.success.destroy')
    end
  end
end
