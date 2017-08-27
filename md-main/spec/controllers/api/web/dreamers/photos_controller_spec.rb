require 'rails_helper'

RSpec.describe Api::Web::Dreamers::PhotosController, type: :controller do
  let(:json) { JSON.parse(response.body) }
  let(:dreamer) { create(:light_dreamer) }
  let(:photo) { create(:photo, dreamer: dreamer) }

  describe 'Dreamer photo' do
    let(:schema) { "#{fixture_path}/schema/v1_dreamer_photos.json" }

    before do
      photo
      sign_in dreamer
      get :index, dreamer_id: dreamer.id
    end

    it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
    it do
      expect(json['photos'].first['id']).to eq photo.id
      expect(json['meta']['status']).to eq 'success'
      expect(json['meta']['code']).to eq 200
      expect(json['meta']['total_count']).to eq 1
    end
  end
end
