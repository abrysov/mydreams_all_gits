require 'rails_helper'

RSpec.describe Api::Web::Countries::CitiesController, type: :controller do
  let(:country) { create :dream_country }
  let(:city) { create :dream_city, dream_country: country }
  let(:json_response) { JSON.parse(response.body) }

  describe 'GET #index' do
    context 'when cities is found' do
      context 'when call with query' do
        before { get :index, country_id: country.id, q: city.name }

        it 'returns searched cities' do
          expect(response).to have_http_status 200
          expect(response.content_type).to eq 'application/json'
          expect(json_response['meta']['code']).to eq 200
          expect(json_response['meta']['status']).to eq 'success'
          expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
          expect(json_response['cities'].first['name']).to eq city.name
        end
      end
    end

    context 'when cities is not found' do
      context 'when call without query' do
        before do
          city
          get :index, country_id: country.id
        end

        it 'returns last 50 cities' do
          expect(response).to have_http_status 200
          expect(response.content_type).to eq 'application/json'
          expect(json_response['meta']['code']).to eq 200
          expect(json_response['meta']['status']).to eq 'success'
          expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
          expect(json_response['cities'].count).to eq 1
        end
      end

      context 'when call with query and not found' do
        before { get :index, country_id: country.id, q: '123' }

        it 'returns error' do
          expect(response).to have_http_status 404
          expect(response.content_type).to eq 'application/json'
          expect(json_response['meta']['code']).to eq 404
          expect(json_response['meta']['status']).to eq 'fail'
          expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
          expect(json_response['cities']).to be_nil
        end
      end
    end
  end

  describe 'POST #create' do
    let(:region) { create :dream_region, dream_country: country }
    let(:district) { create :dream_district, dream_country: country, dream_region: region }

    context 'when city is created' do
      context 'when send all data' do
        let(:city_name) { 'london' }
        let(:params) do
          { country_id: country.id, region_name: region.name,
            district_name: district.name, city_name: city_name }
        end

        before { post :create, params }

        it 'returns created city' do
          expect(response).to have_http_status 201
          expect(response.content_type).to eq 'application/json'
          expect(json_response['meta']['code']).to eq 201
          expect(json_response['meta']['status']).to eq 'success'
          expect(json_response['meta']['message']).to eq I18n.t('api.success.create')
          expect(json_response['city']['id']).to be_truthy
          expect(json_response['city']['name']).to eq capitalize_words(city_name)

          dream_city = DreamCity.find(json_response['city']['id'])
          expect(dream_city.dream_region).to eq region
          expect(dream_city.dream_district).to eq district
        end
      end

      context 'when send not all data' do
        let(:city_name) { 'zztop' }
        let(:params) do
          { country_id: city.dream_country_id, city_name: city_name }
        end

        before { post :create, params }

        it 'returns created city' do
          expect(response).to have_http_status 201
          expect(response.content_type).to eq 'application/json'
          expect(json_response['meta']['code']).to eq 201
          expect(json_response['meta']['status']).to eq 'success'
          expect(json_response['meta']['message']).to eq I18n.t('api.success.create')
          expect(json_response['city']['name']).to eq capitalize_words(city_name)

          dream_city = DreamCity.find(json_response['city']['id'])
          expect(dream_city.dream_region_id).to be_nil
          expect(dream_city.dream_district_id).to be_nil
        end
      end
    end

    context 'when city is not created' do
      context 'when post city that already exists' do
        let(:params) do
          { country_id: city.dream_country.id,
            region_name: city.dream_region.name, district_name: city.dream_district.name,
            city_name: city.name }
        end

        before { post :create, params }

        it 'returns already exists city' do
          expect(response).to have_http_status 201
          expect(response.content_type).to eq 'application/json'
          expect(json_response['meta']['code']).to eq 201
          expect(json_response['meta']['status']).to eq 'success'
          expect(json_response['meta']['message']).to eq I18n.t('api.success.create')
          expect(json_response['city']['id']).to be_truthy
          expect(json_response['city']['name']).to eq capitalize_words(city.name)

          dream_city = DreamCity.find(json_response['city']['id'])
          expect(dream_city.dream_region).to eq city.dream_region
          expect(dream_city.dream_district).to eq city.dream_district

          expect(DreamCity.count).to eq 1
        end
      end

      context 'when not send city name' do
        let(:params) do
          { country_id: country.id, region_name: region.name,
            district_name: district.name }
        end

        before { post :create, params }

        it 'returns error' do
          expect(response).to have_http_status 422
          expect(response.content_type).to eq 'application/json'
          expect(json_response['meta']['code']).to eq 422
          expect(json_response['meta']['status']).to eq 'fail'
          expect(json_response['meta']['message']).to eq I18n.t('api.failure.unprocessable_entity')
          expect(json_response['city']).to be_nil
        end
      end
    end
  end
end
