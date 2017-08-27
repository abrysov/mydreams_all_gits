require 'rails_helper'

RSpec.describe Api::Web::Profile::FriendshipRequestsController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }

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

    before { sign_in dreamer }

    context 'when get friendship requests' do
      let(:expected_friend) { create :light_dreamer }

      before do
        friend_request
        get :index
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
        get :index, outgoing: true
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
        get :index, online: true
      end

      it { expect(json_response['friendship_requests'].first['id']).to eq friend_request.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get outgoing friendship_requests filtered by online status' do
      let(:expected_friend) { create :light_dreamer, last_reload_at: Time.zone.now }

      before do
        outgoing_friend_request
        another_outgoing_friend_request
        get :index, outgoing: true, online: true
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
        get :index, vip: true
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
        get :index, outgoing: true, vip: true
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
        get :index, gender: :female
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
        get :index, outgoing: true, gender: :female
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
        get :index, age: { from: 30 }
      end

      it { expect(json_response['friendship_requests'].first['id']).to eq friend_request.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get outgoing friendship_requests filtered by age' do
      let(:expected_friend) { create :light_dreamer, birthday: 20.years.ago }

      before do
        outgoing_friend_request
        another_outgoing_friend_request
        get :index, outgoing: true, age: { to: 20 }
      end

      it { expect(friendship_requests_ids).to be_include outgoing_friend_request.id }
    end

    context 'get friendship_requests filtered by city_id' do
      let(:city) { create :dream_city }
      let(:expected_friend) { create :light_dreamer, dream_city: city }

      before do
        friend_request
        another_friend_request
        get :index, city_id: city.id
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
        get :index, outgoing: true, city_id: city.id
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
        get :index, country_id: country.id
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
        get :index, outgoing: true, country_id: country.id
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
      let(:params) { { id: receiver.id } }

      before do
        sign_in dreamer
        post :create, params
      end

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
      let(:params) { { id: outgoing_friend_request.receiver.id } }

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

  describe 'DELETE request #destroy' do
    let(:dreamer) { create :dreamer }
    let(:outgoing_friend_request) { create :friend_request, sender: dreamer }

    before do
      sign_in dreamer
      delete :destroy, id: outgoing_friend_request.receiver.id
    end

    it { expect(FriendRequest.find_by(id: outgoing_friend_request.id)).to be_nil }
    it do
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['status']).to eq 'success'
      expect(json_response['meta']['message']).to eq I18n.t('api.success.destroy')
    end
  end

  describe 'DELETE friendship #destroy' do
    let(:dreamer) { create :dreamer }
    let(:friend) { create :dreamer }
    let(:outgoing_friends) { create :friendship, friend: friend }

    before do
      sign_in dreamer
      delete :destroy, id: friend.id
    end

    it do
      friendship = Friendship.find_by 'friendships.member_ids @> ARRAY[?, ?]', dreamer.id, friend.id
      expect(friendship).to be_nil
    end
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
        sign_in dreamer
        friend_request
        post :accept, id: friend_request.sender.id
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
        sign_in dreamer
        friend_request
        post :reject, id: friend_request.sender.id
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
