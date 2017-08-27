require 'rails_helper'

RSpec.describe Api::Web::DreamersController, type: :controller do
  let(:json) { JSON.parse(subject.body) }

  describe 'Dreamers list' do
    let(:schema) { "#{fixture_path}/schema/v1_dreamers.json" }
    let(:dreamers) { create_list(:light_dreamer, 3) }

    context 'GET index' do
      let(:request_params) do
        {
          per: dreamers.count,
          page: 1
        }
      end

      subject { get :index, request_params }

      it { expect(subject.status).to eq 200 }
      it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
      it do
        expect(json['dreamers'].count).to eq request_params[:per]
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
        expect(json['meta']['per']).to eq request_params[:per]
        expect(json['meta']['page']).to eq request_params[:page]
        expect(json['meta']['total_count']).to eq dreamers.count
      end
    end
  end

  describe 'GET #show' do
    let(:dreamer) { create :dreamer }
    let(:schema) { "#{fixture_path}/schema/v1_dreamer_show.json" }
    let(:json_response) { JSON.parse(response.body) }

    context 'when success show' do
      before { get :show, id: dreamer.id }

      it { expect(response.status).to eq 200 }
      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        subject.status.should eq 200
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end

    context 'when failed show' do
      before { get :show, id: 1234 }

      it { expect(response.status).to eq 404 }
      it do
        subject.status.should eq 404
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
      end
    end
  end
end
