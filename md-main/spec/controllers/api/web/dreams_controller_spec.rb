require 'rails_helper'

RSpec.describe Api::Web::DreamsController, type: :controller do
  let(:dreams) { create_list(:dream, 4) }
  let(:json_response) { JSON.parse(response.body) }
  let(:schema) { "#{fixture_path}/schema/web_dream.json" }
  let(:schema_dreams) { "#{fixture_path}/schema/v1_dreams.json" }

  describe 'GET #index' do
    context 'show dreams ' do
      let(:request_params) do
        {
          per: dreams.count,
          page: 1
        }
      end

      before { get :index, request_params }

      it do
        expect(JSON::Validator.validate!(schema_dreams, response.body, strict: true)).to be true
      end
      it do
        expect(json_response['meta']['code']).to eq(200)
        expect(json_response['meta']['status']).to eq('success')
        expect(json_response['meta']['per']).to eq request_params[:per]
        expect(json_response['meta']['page']).to eq request_params[:page]
        expect(json_response['meta']['total_count']).to eq dreams.count
        expect(json_response['dreams'].count).to eq request_params[:per]
      end
    end

    context 'when get dreams ordered by launches count' do
      let(:dream_with_launches) { create :dream, launches_count: 10 }

      before do
        dream_with_launches
        get :index, launches: true
      end

      it { expect(json_response['dreams'].first['id']).to eq dream_with_launches.id }
    end
  end

  describe 'create' do
    let(:dreamer) { create(:light_dreamer) }

    context 'new dreams' do
      let(:request_params) { attributes_for(:dream) }
      before do
        request_params[:restriction_level] = 'friends'
        request_params[:photo] = fixture_file_upload('avatar.jpg', 'image/jpg')
        request_params[:photo_crop] = { x: 10, y: 10, width: 20, height: 10 }
        sign_in dreamer
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
        expect(json_response['dream']['restriction_level']).to eq 'friends'
        expect(json_response['dream']['title']).to eq dream.title
      end
    end

    context 'failed' do
      let(:request_params) { attributes_for(:dream) }
      before do
        sign_in dreamer
        request_params.delete(:title)
        post :create, request_params
      end

      it do
        expect(json_response['meta']['code']).to eq 400
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.unprocessable_entity')
      end
    end
  end

  describe 'show' do
    let(:dreamer) { create(:light_dreamer) }

    context 'when dream show all and success' do
      let(:dream) { create :dream, restriction_level: 0 }
      before do
        sign_in dreamer
        get :show, id: dream.id
      end

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
        sign_in dreamer
        Relations::SendFriendRequest.call(from: dream.dreamer, to: dreamer)
        Relations::AcceptFriendRequest.call(dream.dreamer, dreamer)
        get :show, id: dream.id
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
    end

    context 'when dream show only to friend and fail' do
      let(:dream) { create :dream, restriction_level: 1 }
      before do
        sign_in dreamer
        get :show, id: dream.id
      end

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end

    context 'when dream has private access and success' do
      let(:private_dream) { create :dream, restriction_level: 2 }
      before do
        sign_in private_dream.dreamer
        get :show, id: private_dream.id
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
    end

    context 'when dream has privat access and fail' do
      let(:private_dream) { create :dream, restriction_level: 2 }
      before do
        sign_in dreamer
        get :show, id: private_dream.id
      end

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end

    context 'when failed search dream' do
      let(:dream) { create :dream }
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

    context 'when show deleted dreams' do
      let(:dream) { create :dream, deleted_at: Time.now }

      before do
        sign_in dreamer
        get :show, id: dream.id
      end

      it { expect(response.response_code).to eq 404 }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
      end
    end
  end

  describe 'update' do
    let(:dreamer) { create(:light_dreamer) }

    context 'when success update' do
      let(:dream) { create :dream, dreamer: dreamer }
      let(:attributes) do
        {
          id: dream.id,
          title: 'updated title',
          photo: fixture_file_upload('avatar.jpg', 'image/jpg'),
          photo_crop: { x: 100, y: 100, width: 400, height: 400 }
        }
      end

      before do
        sign_in dreamer
        put :update, attributes
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
      end
      it { expect(dream.reload.title).to eq 'updated title' }
      it { expect(dream.reload.photo_crop).not_to be_nil }
    end

    context 'when failed update' do
      let(:dream) { create :dream, dreamer: dreamer }
      let(:attr) do
        {
          id: dream.id,
          title: ''
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

  describe 'destroy' do
    let(:dream) { create :dream }

    before do
      sign_in dream.dreamer
      delete :destroy, id: dream.id
    end

    it { expect(dream.reload.deleted?).to eq true }
    it do
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['status']).to eq 'success'
      expect(json_response['meta']['message']).to eq I18n.t('api.success.destroy')
    end
  end
end
