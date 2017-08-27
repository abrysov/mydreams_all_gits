require 'rails_helper'

RSpec.describe Api::Web::LeadersController, type: :controller do
  let(:dreamer) { create(:light_dreamer) }
  let(:photo) { create(:photo, dreamer: dreamer) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
  let(:json) { JSON.parse(subject.body) }

  describe 'GET #index' do
    let(:schema) { "#{fixture_path}/schema/web_leaders.json" }

    context 'leaders' do
      before do
        dreamer.photobar_added_at = Time.now
        dreamer.photobar_added_text = 'hello world'
        dreamer.photobar_added_photo_id = photo.id
        dreamer.save!(validates: false)
      end

      subject { get :index }

      it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
      it do
        subject.status.should eq 200
        expect(json['leaders'].first['id']).to eq dreamer.id
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
      end
    end
  end

  describe 'POST #create' do
    context 'create' do
      let(:dreamer_json) { JSON.parse(response.body) }
      let(:request_params) do
        {
          photo_id: photo.id,
          message: 'hello world'
        }
      end
      before do
        sign_in dreamer
        post :create, request_params
      end

      it do
        expect(response.status).to eq 200
        expect(dreamer_json['dreamer_photobar']['id']).to eq dreamer.id
        expect(dreamer_json['meta']['code']).to eq 200
        expect(dreamer_json['meta']['status']).to eq 'success'
      end
      it do
        dreamer.reload
        expect(dreamer.photobar_added_photo_id).to eq photo.id
        expect(dreamer.photobar_added_at).not_to be_nil
        expect(dreamer.photobar_added_text).to eq 'hello world'
      end
    end
  end
end
