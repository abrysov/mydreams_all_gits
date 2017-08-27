require 'rails_helper'

RSpec.describe Api::V1::DreamersController, type: :controller do
  let(:json) { JSON.parse(subject.body) }

  describe 'Dreamers list' do
    let(:schema) { "#{fixture_path}/schema/v1_dreamers.json" }
    let(:dreamers) { create_list(:light_dreamer, 3) }
    let(:dreamer) { create(:light_dreamer) }
    let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }

    context 'GET index' do
      let(:request_params) do
        {
          access_token: token,
          per: dreamers.count,
          page: 1
        }
      end

      subject { get :index, request_params }

      it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
      it do
        expect(subject.status).to eq 200
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
        expect(json['meta']['per']).to eq request_params[:per]
        expect(json['meta']['page']).to eq request_params[:page]
        expect(json['meta']['total_count']).to eq dreamers.count
        expect(json['dreamers'].count).to eq request_params[:per]
      end
    end

    context 'one young dreamer' do
      let(:request_params) do
        {
          access_token: token,
          per: dreamers.count,
          age_to: 11
        }
      end
      before do
        create(:dreamer, :young)
      end

      subject { get :index, request_params }

      it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
      it do
        expect(subject.status).to eq 200
        expect(json['meta']['code']).to eq 200
        expect(json['dreamers'].count).to eq 1
      end
    end
  end

  describe 'Dremers create' do
    let(:dreamer_params) { attributes_for(:light_dreamer) }

    context 'empty data' do
      subject { post :create }

      it do
        expect(subject.status).to eq 422
        expect(json['meta']['code']).to eq 422
        expect(json['meta']['message']).to eq I18n.t('devise.registrations.validation_failed')
        expect(json['meta']['errors']).not_to be_nil
        expect(json['meta']['status']).to eq 'fail'
      end
    end

    context 'invalid params' do
      subject { post :create, dreamer_params.merge(email: 'yolo', password: nil) }

      it do
        expect(subject.status).to eq 422
        expect(json['meta']['code']).to eq 422
        expect(json['meta']['message']).to eq I18n.t('devise.registrations.validation_failed')
        expect(json['meta']['errors']).not_to be_nil
        expect(json['meta']['status']).to eq 'fail'
      end
    end

    context 'create dreamer' do
      let(:json) { JSON.parse(response.body) }
      let(:schema) { "#{fixture_path}/schema/v1_dreamer_create.json" }

      before { post :create, dreamer_params }

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(response.status).to eq 201
        expect(json['meta']['code']).to eq 201
        expect(json['meta']['message']).to eq I18n.t('devise.registrations.signed_up')
        expect(json['meta']['status']).to eq 'success'
      end
      it do
        dreamer = Dreamer.where(email: dreamer_params[:email]).first

        expect(json['dreamer']['id']).to eq(dreamer.id)
        expect(json['dreamer']['first_name']).to eq(dreamer.first_name)
        expect(json['dreamer']['last_name']).to eq(dreamer.last_name)
        expect(json['dreamer']['full_name']).to eq("#{dreamer.first_name} #{dreamer.last_name}".strip)
        expect(json['dreamer']['gender']).to eq(dreamer.gender)
        expect(json['dreamer']['city']).to eq(dreamer.city_name)
        expect(json['dreamer']['country']).to eq(dreamer.country_name)
        expect(json['dreamer']['vip']).to eq(dreamer.is_vip?)
        expect(json['dreamer']['celebrity']).to eq(dreamer.celebrity || false)
        expect(json['dreamer']['friends_count']).to eq(dreamer.friends.count)
        expect(json['dreamer']['dreams_count']).to eq(dreamer.dreams.count)
        expect(json['dreamer']['fulfilled_dreams_count']).to eq 0
        expect(json['dreamer']['views_count']).to eq(dreamer.passive_visits.count)
        expect(json['dreamer']['is_deleted']).to eq(false)
        expect(json['dreamer']['is_blocked']).to eq(false)
      end
    end
  end

  describe 'GET #show' do
    let(:dreamer) { create :dreamer }
    let(:doorkeeper) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id) }
    let(:schema) { "#{fixture_path}/schema/v1_dreamer_show.json" }
    let(:json_response) { JSON.parse(response.body) }

    context 'when success show' do
      before { get :show, access_token: doorkeeper.token, id: dreamer.id }

      it { expect(response.status).to eq 200 }
      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        subject.status.should eq 200
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end

    context 'when failed show' do
      before { get :show, access_token: doorkeeper.token, id: 1234 }

      it { expect(response.status).to eq 404 }
      it do
        subject.status.should eq 404
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
      end
    end
  end
end
