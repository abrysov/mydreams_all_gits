require 'rails_helper'

RSpec.describe Api::Web::MesController, type: :controller do
  describe 'GET #show' do
    let(:dreamer) { create(:light_dreamer) }
    let(:json_response) { JSON.parse(response.body) }
    let(:schema) { "#{fixture_path}/schema/v1_mes.json" }

    context 'return current dreamer' do
      before do
        sign_in dreamer
        get :show
      end

      it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
      it do
        expect(response.status).to eq 200
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end
  end
end
