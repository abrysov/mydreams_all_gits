require 'rails_helper'

RSpec.describe Api::Web::CountriesController, type: :controller do
  let(:dreamer) { create(:vip_dreamer, :female) }
  let(:country) { create :dream_country, name: 'London' }
  let(:json_response) { JSON.parse(subject.body) }

  before do
    country
  end

  describe 'GET #index' do
    context 'when countries is found' do
      context 'when call without query' do
        subject { get :index }
        it 'returns all countries' do
          is_expected.to have_http_status 200
          expect(subject.content_type).to eq 'application/json'
          expect(json_response['meta']['code']).to eq 200
          expect(json_response['meta']['status']).to eq 'success'
          expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
          expect(json_response['countries'].count).to eq 1
        end
      end

      context 'when call with query' do
        subject { get :index, q: country.name }
        it 'returns searched country' do
          is_expected.to have_http_status 200
          expect(subject.content_type).to eq 'application/json'
          expect(json_response['meta']['code']).to eq 200
          expect(json_response['meta']['status']).to eq 'success'
          expect(json_response['meta']['message']).to eq I18n.t('api.success.search')
          expect(json_response['countries'].first['name']).to eq country.name
        end
      end
    end

    context 'when countries is not found' do
      subject { get :index, q: '123' }
      it 'returns error' do
        is_expected.to have_http_status 404
        expect(subject.content_type).to eq 'application/json'
        expect(json_response['meta']['code']).to eq(404)
        expect(json_response['meta']['status']).to eq('fail')
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.not_found')
        expect(json_response['countries']).to be_nil
      end
    end
  end
end
