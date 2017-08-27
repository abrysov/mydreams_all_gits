require 'rails_helper'

RSpec.describe Api::V1::Profile::FriendshipRequestsController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }

  describe 'GET #index' do
    let(:schema) { "#{fixture_path}/schema/v1_friendship_requests.json" }
    let(:dreamer) { create :light_dreamer }

    let(:friendship_requests_ids) { json_response['friendship_requests'].map { |r| r['id'] } }

    let(:friend_request) { create :friend_request, sender: expected_friend, receiver: dreamer }
    let(:another_friend_request) { create :friend_request, receiver: dreamer }
    let(:outgoing_friend_request) do
      create :friend_request, sender: dreamer, receiver: expected_friend
    end
    let(:another_outgoing_friend_request) { create :friend_request, sender: dreamer }

    context 'when get friendship requests' do
      let(:expected_friend) { create :light_dreamer }

      before do
        friend_request
        get :index, access_token: token
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(json_response['friendship_requests'].count).to eq 1 }
      it { expect(json_response['friendship_requests'].first['receiver']['id']).to eq dreamer.id }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['total_count']).to eq 1
      end
    end

    context 'when get outgoing friendship requests' do
      let(:expected_friend) { create :light_dreamer }

      before do
        outgoing_friend_request
        get :index, outgoing: true, access_token: token
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(json_response['friendship_requests'].count).to eq 1 }
      it { expect(json_response['friendship_requests'].first['sender']['id']).to eq dreamer.id }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['total_count']).to eq 1
      end
    end

    context 'get friendship_requests filtered by online status' do
      let(:expected_friend) { create :light_dreamer, last_reload_at: Time.zone.now }

      before do
        friend_request
        another_friend_request
        get :index, access_token: token, online: true
      end

      it { expect(json_response['friendship_requests'].first['id']).to eq friend_request.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get outgoing friendship_requests filtered by online status' do
      let(:expected_friend) { create :light_dreamer, last_reload_at: Time.zone.now }

      before do
        outgoing_friend_request
        another_outgoing_friend_request
        get :index, access_token: token, outgoing: true, online: true
      end

      it do
        expect(json_response['friendship_requests'].first['id']).to eq outgoing_friend_request.id
      end
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get friendship_requests filtered by vip status' do
      let(:expected_friend) { create :light_dreamer, is_vip: true }

      before do
        friend_request
        another_friend_request
        get :index, access_token: token, vip: true
      end

      it do
        expect(json_response['friendship_requests'].first['id']).to eq friend_request.id
      end
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get outgoing friendship_requests filtered by vip status' do
      let(:expected_friend) { create :light_dreamer, is_vip: true }

      before do
        outgoing_friend_request
        another_outgoing_friend_request
        get :index, access_token: token, outgoing: true, vip: true
      end

      it do
        expect(json_response['friendship_requests'].first['id']).to eq outgoing_friend_request.id
      end
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get friendship_requests filtered by gender' do
      let(:expected_friend) { create :light_dreamer, gender: :female }

      before do
        friend_request
        another_friend_request
        get :index, access_token: token, gender: :female
      end

      it do
        expect(json_response['friendship_requests'].first['id']).to eq friend_request.id
      end
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get outgoing friendship_requests filtered by gender' do
      let(:expected_friend) { create :light_dreamer, gender: :female }

      before do
        outgoing_friend_request
        another_outgoing_friend_request
        get :index, access_token: token, outgoing: true, gender: :female
      end

      it do
        expect(json_response['friendship_requests'].first['id']).to eq outgoing_friend_request.id
      end
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get friendship_requests filtered by age' do
      let(:expected_friend) { create :light_dreamer, birthday: 30.years.ago }

      before do
        friend_request
        another_friend_request
        get :index, access_token: token, age: { from: 30 }
      end

      it { expect(json_response['friendship_requests'].first['id']).to eq friend_request.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get outgoing friendship_requests filtered by age' do
      let(:expected_friend) { create :light_dreamer, birthday: 20.years.ago }

      before do
        outgoing_friend_request
        another_outgoing_friend_request
        get :index, access_token: token, outgoing: true, age: { to: 20 }
      end

      it { expect(friendship_requests_ids).to be_include outgoing_friend_request.id }
    end

    context 'get friendship_requests filtered by city_id' do
      let(:city) { create :dream_city }
      let(:expected_friend) { create :light_dreamer, dream_city: city }

      before do
        friend_request
        another_friend_request
        get :index, access_token: token, city_id: city.id
      end

      it { expect(json_response['friendship_requests'].first['id']).to eq friend_request.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get outgoing friendship_requests filtered by city_id' do
      let(:city) { create :dream_city }
      let(:expected_friend) { create :light_dreamer, dream_city: city }

      before do
        outgoing_friend_request
        another_outgoing_friend_request
        get :index, access_token: token, outgoing: true, city_id: city.id
      end

      it do
        expect(json_response['friendship_requests'].first['id']).to eq outgoing_friend_request.id
      end
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get friendship_requests filtered by country_id' do
      let(:country) { create :dream_country }
      let(:expected_friend) { create :light_dreamer, dream_country: country }

      before do
        friend_request
        another_friend_request
        get :index, access_token: token, country_id: country.id
      end

      it do
        expect(json_response['friendship_requests'].first['id']).to eq friend_request.id
      end
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get outgoing friendship_requests filtered by country_id' do
      let(:country) { create :dream_country }
      let(:expected_friend) { create :light_dreamer, dream_country: country }

      before do
        outgoing_friend_request
        another_outgoing_friend_request
        get :index, access_token: token, outgoing: true, country_id: country.id
      end

      it do
        expect(json_response['friendship_requests'].first['id']).to eq outgoing_friend_request.id
      end
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end
  end

  describe 'POST #create' do
    let(:schema) { "#{fixture_path}/schema/v1_friendship_request.json" }
    let(:dreamer) { create :dreamer }

    context 'when success create' do
      let(:receiver) { create :dreamer }
      let(:params) { { access_token: token, id: receiver.id } }

      before { post :create, params }

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it { expect(dreamer.reload.outgoing_friend_requests.last.receiver).to eq receiver }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq I18n.t('api.success.create')
      end
    end

    context 'when failed create' do
      let(:outgoing_friend_request) { create :friend_request, sender: dreamer }
      let(:params) { { access_token: token, id: outgoing_friend_request.receiver.id } }

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
    let(:dreamer) { create :dreamer }
    let(:outgoing_friend_request) { create :friend_request, sender: dreamer }

    before do
      delete :destroy, id: outgoing_friend_request.receiver.id, access_token: token
    end

    it { expect(FriendRequest.find_by(id: outgoing_friend_request.id)).to be_nil }
    it do
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['status']).to eq 'success'
      expect(json_response['meta']['message']).to eq I18n.t('api.success.destroy')
    end
  end

  describe 'POST #accept' do
    let(:dreamer) { create :dreamer }

    context 'when success' do
      let(:friend_request) { create :friend_request, receiver: dreamer }

      before do
        friend_request
        post :accept, access_token: token, id: friend_request.sender.id
      end

      it { expect(FriendRequest.find_by(id: friend_request.id)).to be_nil }

      it { expect(dreamer.reload.friends).to be_include friend_request.sender }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['message']).to eq I18n.t('api.success.create')
      end
    end
  end

  describe 'POST #reject' do
    let(:dreamer) { create :dreamer }

    context 'when success' do
      let(:friend_request) { create :friend_request, receiver: dreamer }

      before do
        friend_request
        post :reject, access_token: token, id: friend_request.sender.id
      end

      it { expect(FriendRequest.find_by(id: friend_request.id)).to be_nil }

      it { expect(dreamer.reload.friends).not_to be_include friend_request.sender }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['message']).to eq I18n.t('api.success.destroy')
      end
    end
  end
end
