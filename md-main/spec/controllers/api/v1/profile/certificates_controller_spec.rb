require 'rails_helper'

RSpec.describe Api::V1::Profile::CertificatesController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }

  describe 'GET #index' do
    let(:schema) { "#{fixture_path}/schema/v1_certificates.json" }
    let(:dream) { create :dream }
    let(:dreamer) { dream.dreamer }
    let(:gifted_by) { create :dreamer }

    let(:buyed_certificate) do
      create :certificate, paid: true, certifiable: dream, created_at: 10.days.ago,
                           launches: 10
    end
    let(:gifted_certificate) do
      create :certificate, accepted: false, gifted_by: gifted_by, certifiable: dream,
                           created_at: Time.zone.now, launches: 5
    end
    let(:certificates_ids) { json_response['certificates'].map { |c| c['id'] } }

    before do
      buyed_certificate
      gifted_certificate
    end

    context 'when get all certificates' do
      before { get :index, access_token: token }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(json_response['certificates'].count).to eq 2 }
      id do
        expect(certificates_ids).to be_include buyed_certificate.id
        expect(certificates_ids).to be_include gifted_certificate.id
      end
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['total_count']).to eq 2
      end
    end

    context 'when get buyed certificates' do
      before { get :index, access_token: token, paid: true }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(json_response['certificates'].count).to eq 1 }
      it { expect(json_response['certificates'].first['id']).to eq buyed_certificate.id }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['total_count']).to eq 1
      end
    end

    context 'when get gifted certificates' do
      before { get :index, access_token: token, gifted: true }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(json_response['certificates'].count).to eq 1 }
      it { expect(json_response['certificates'].first['id']).to eq gifted_certificate.id }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['total_count']).to eq 1
      end
    end

    context 'when get certificates ordered by created date' do
      before { get :index, access_token: token, new: true }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(json_response['certificates'].first['id']).to eq gifted_certificate.id }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['total_count']).to eq 2
      end
    end

    context 'when get certificates ordered by launches count(status)' do
      before { get :index, access_token: token, launches: true }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(json_response['certificates'].first['id']).to eq buyed_certificate.id }
      it do
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['total_count']).to eq 2
      end
    end
  end
end
