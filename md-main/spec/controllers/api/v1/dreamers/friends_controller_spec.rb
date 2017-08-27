require 'rails_helper'

RSpec.describe Api::V1::Dreamers::FriendsController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }
  let(:schema) { "#{fixture_path}/schema/v1_friends.json" }

  let(:dreamer) { create :light_dreamer }
  let(:friend) { create :light_dreamer, gender: :male, birthday: 20.years.ago }

  let(:friendship) { create :friendship, dreamer: dreamer, friend: friend }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }

  before { friendship }

  describe 'GET #index' do
    let(:new_friendship) { create :accepted_friendship, dreamer: dreamer, friend: expected_friend }
    let(:friends_ids) { json_response['friends'].map { |friend| friend['id'] } }

    context 'get friends without filtering' do
      before { get :index, dreamer_id: dreamer.id, access_token: token }

      it { expect(response.status).to eq 200 }
      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it { expect(json_response['friends'].first['id']).to eq friend.id }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['total_count']).to eq 1
      end
    end

    context 'when failed find dreamer' do
      before { get :index, dreamer_id: 1234, access_token: token }

      it { expect(response).to be_not_found }
    end

    context 'get friends filtered by online status' do
      let(:expected_friend) { create :light_dreamer, last_reload_at: Time.zone.now }

      before do
        new_friendship
        get :index, dreamer_id: dreamer.id, access_token: token, online: true
      end

      it { expect(json_response['friends'].first['id']).to eq expected_friend.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get friends filtered by online status' do
      let(:expected_friend) { create :light_dreamer, is_vip: true }

      before do
        new_friendship
        get :index, dreamer_id: dreamer.id, access_token: token, vip: true
      end

      it { expect(json_response['friends'].first['id']).to eq expected_friend.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get friends filtered by gender male' do
      let(:expected_friend) { create :light_dreamer, gender: :male }

      before do
        new_friendship
        get :index, dreamer_id: dreamer.id, access_token: token, gender: :male
      end

      it do
        expect(friends_ids).to be_include friend.id
        expect(friends_ids).to be_include expected_friend.id
      end
      it { expect(json_response['meta']['total_count']).to eq 2 }
    end

    context 'get friends filtered by gender female' do
      let(:expected_friend) { create :light_dreamer, gender: :female }

      before do
        new_friendship
        get :index, dreamer_id: dreamer.id, access_token: token, gender: :female
      end

      it { expect(json_response['friends'].first['id']).to eq expected_friend.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get friends filtered by age from' do
      let(:expected_friend) { create :light_dreamer, birthday: 30.years.ago }

      before do
        new_friendship
        get :index, dreamer_id: dreamer.id, access_token: token, age: { from: 30 }
      end

      it { expect(json_response['friends'].first['id']).to eq expected_friend.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get friends filtered by age to' do
      let(:expected_friend) { create :light_dreamer, birthday: 50.years.ago }

      before do
        new_friendship
        get :index, dreamer_id: dreamer.id, access_token: token, age: { to: 50 }
      end

      it do
        expect(friends_ids).to be_include friend.id
        expect(friends_ids).to be_include expected_friend.id
      end
      it { expect(json_response['meta']['total_count']).to eq 2 }
    end

    context 'get friends filtered by city_id' do
      let(:city) { create :dream_city }
      let(:expected_friend) { create :light_dreamer, dream_city: city }

      before do
        new_friendship
        get :index, dreamer_id: dreamer.id, access_token: token, city_id: city.id
      end

      it { expect(json_response['friends'].first['id']).to eq expected_friend.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get friends filtered by country_id' do
      let(:country) { create :dream_country }
      let(:expected_friend) { create :light_dreamer, dream_country: country }

      before do
        new_friendship
        get :index, dreamer_id: dreamer.id, access_token: token, country_id: country.id
      end

      it { expect(json_response['friends'].first['id']).to eq expected_friend.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end
  end
end
