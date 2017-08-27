require 'rails_helper'

RSpec.describe Api::V1::Dreamers::PhotosController, type: :controller do
  let(:json) { JSON.parse(subject.body) }
  let(:dreamer) { create(:light_dreamer) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
  let(:photo) { create(:photo, dreamer: dreamer) }

  describe 'Dreamer photo' do
    let(:schema) { "#{fixture_path}/schema/v1_dreamer_photos.json" }

    before { photo }
    subject { get :index, dreamer_id: dreamer.id, access_token: token }

    it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
    it do
      expect(json['photos'].first['id']).to eq photo.id
      expect(json['meta']['status']).to eq 'success'
      expect(json['meta']['code']).to eq 200
      expect(json['meta']['total_count']).to eq 1
    end
  end
end
