require 'rails_helper'

RSpec.describe Api::Web::Profile::FolloweesController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }
  let(:schema) { "#{fixture_path}/schema/web_followees.json" }

  let(:follower) { create :light_dreamer }
  let(:follower_friend) { create :light_dreamer }
  let(:followee_1) { create :light_dreamer, gender: :male }
  let(:followees_ids) { json_response['dreamers'].map { |followee| followee['id'] } }

  describe 'GET #index' do
    before do
      sign_in follower
      follower.subscribe_to(followee_1)
      follower.subscribe_to(followee_2)
    end

    context 'get followees without filtering' do
      let(:followee_2) { create :light_dreamer }

      before do
        Relations::SendFriendRequest.call(from: follower, to: follower_friend)
        Relations::AcceptFriendRequest.call(follower, follower_friend)
        get :index
      end

      it { expect(followees_ids).to be_include followee_1.id }
      it { expect(followees_ids).to be_include followee_2.id }
      it { expect(followees_ids).not_to be_include(follower_friend.id) }
      it { expect(response.status).to eq 200 }
      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['total_count']).to eq 2
      end
    end

    context 'get followees filtered by online status' do
      let(:followee_2) { create :light_dreamer, last_reload_at: Time.zone.now }

      before { get :index, online: true }

      it { expect(json_response['dreamers'].first['id']).to eq followee_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get followees filtered by vip status' do
      let(:followee_2) { create :light_dreamer, is_vip: true }

      before { get :index, vip: true }

      it { expect(json_response['dreamers'].first['id']).to eq followee_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get followees filtered by gender male' do
      let(:followee_2) { create :light_dreamer, gender: :female }

      before { get :index, gender: :female }

      it { expect(followees_ids).to be_include followee_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get followees filtered by age from' do
      let(:followee_2) { create :light_dreamer, birthday: 30.years.ago }

      before { get :index, age: { from: 30 } }

      it { expect(json_response['dreamers'].first['id']).to eq followee_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get followees filtered by city_id' do
      let(:city) { create :dream_city }
      let(:followee_2) { create :light_dreamer, dream_city: city }

      before { get :index, city_id: city.id }

      it { expect(json_response['dreamers'].first['id']).to eq followee_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get followees filtered by country_id' do
      let(:country) { create :dream_country }
      let(:followee_2) { create :light_dreamer, dream_country: country }

      before { get :index, country_id: country.id }

      it { expect(json_response['dreamers'].first['id']).to eq followee_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end
  end
end
