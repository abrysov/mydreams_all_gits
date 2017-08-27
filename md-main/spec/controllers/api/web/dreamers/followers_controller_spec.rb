require 'rails_helper'

RSpec.describe Api::Web::Dreamers::FollowersController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }
  let(:schema) { "#{fixture_path}/schema/web_followers.json" }

  let(:followee) { create :light_dreamer }
  let(:followers_ids) { json_response['dreamers'].map { |follower| follower['id'] } }

  describe 'GET #index' do
    let(:follower_1) { create :light_dreamer, gender: :male }

    before do
      sign_in followee
      follower_1.subscribe_to(followee)
      follower_2.subscribe_to(followee)
    end

    context 'get followers without filtering' do
      let(:follower_2) { create :light_dreamer }

      before { get :index, dreamer_id: followee.id }

      it { expect(followers_ids).to be_include follower_1.id }
      it { expect(followers_ids).to be_include follower_2.id }
      it { expect(response.status).to eq 200 }
      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['total_count']).to eq 2
      end
    end

    context 'get followers filtered by online status' do
      let(:follower_2) { create :light_dreamer, last_reload_at: Time.zone.now }

      before { get :index, dreamer_id: followee.id, online: true }

      it { expect(json_response['dreamers'].first['id']).to eq follower_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get followers filtered by vip status' do
      let(:follower_2) { create :light_dreamer, is_vip: true }

      before { get :index, dreamer_id: followee.id, vip: true }

      it { expect(json_response['dreamers'].first['id']).to eq follower_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get followers filtered by gender male' do
      let(:follower_2) { create :light_dreamer, gender: :female }

      before { get :index, dreamer_id: followee.id, gender: :female }

      it { expect(followers_ids).to be_include follower_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get followers filtered by age from' do
      let(:follower_2) { create :light_dreamer, birthday: 30.years.ago }

      before { get :index, dreamer_id: followee.id, age: { from: 30 } }

      it { expect(json_response['dreamers'].first['id']).to eq follower_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get followers filtered by city_id' do
      let(:city) { create :dream_city }
      let(:follower_2) { create :light_dreamer, dream_city: city }

      before { get :index, dreamer_id: followee.id, city_id: city.id }

      it { expect(json_response['dreamers'].first['id']).to eq follower_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end

    context 'get friends filtered by country_id' do
      let(:country) { create :dream_country }
      let(:follower_2) { create :light_dreamer, dream_country: country }

      before { get :index, dreamer_id: followee.id, country_id: country.id }

      it { expect(json_response['dreamers'].first['id']).to eq follower_2.id }
      it { expect(json_response['meta']['total_count']).to eq 1 }
    end
  end
end
