require 'rails_helper'

RSpec.describe Api::V1::MesController, type: :controller do
  describe 'GET #show' do
    let(:dreamer) { create(:vip_dreamer, :female) }
    let(:doorkeeper) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id) }
    let(:json_response) { JSON.parse(subject.body) }
    let(:schema) { "#{fixture_path}/schema/v1_mes.json" }

    context 'status with 401' do
      subject { get :show }

      it do
        subject.status.should eq 401
        expect(json_response['meta']['code']).to eq 401
        expect(json_response['meta']['status']).to eq 'fail'
      end
    end

    context 'return current dreamer' do
      subject { get :show, access_token: doorkeeper.token }

      it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
      it do
        subject.status.should eq 200
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
    end
  end
end
