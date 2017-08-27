require 'rails_helper'

RSpec.describe Api::Web::Top::DreamsController, type: :controller do
  let(:top_dreams) { create_list(:top_dream, 5) }
  let(:dreamer) { create(:light_dreamer) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
  let(:json) { JSON.parse(subject.body) }

  describe 'GET #index' do
    context 'show top dreams ' do
      let(:schema) { "#{fixture_path}/schema/v1_top_dreams.json" }
      let(:request_params) do
        {
          access_token: token,
          per: 2,
          page: 2
        }
      end

      before  { top_dreams }
      subject { get :index, request_params }

      it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
      it do
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
        expect(json['meta']['per']).to eq request_params[:per]
        expect(json['meta']['page']).to eq request_params[:page]
        expect(json['meta']['total_count']).to eq top_dreams.count
        expect(json['meta']['remaining_count']).to eq 1
      end
    end
  end
end
