require 'rails_helper'

RSpec.describe Api::Web::Dreamers::FeedsController, type: :controller do
  let(:dreamer) { create(:light_dreamer) }
  let(:json_response) { JSON.parse(response.body) }
  let(:schema) { "#{fixture_path}/schema/v1_feeds.json" }

  describe 'GET #show' do
    let(:another_dreamer) { create(:light_dreamer) }
    let(:post_ids) { json_response['feeds'].map { |post| post['id'] } }
    let(:allow_post_1) { create :post, dreamer: another_dreamer, restriction_level: 0 }
    let(:allow_post_2) { create :post, dreamer: another_dreamer, restriction_level: 0 }
    let(:deny_post) { create :post, dreamer: another_dreamer, restriction_level: 2 }

    before do
      sign_in dreamer
      allow_post_1
      allow_post_2
      deny_post
      get :index, dreamer_id: another_dreamer.id
    end

    it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
    it do
      expect(post_ids).to be_include(allow_post_1.id)
      expect(post_ids).to be_include(allow_post_2.id)
      expect(post_ids).not_to be_include(deny_post.id)
    end
    it do
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['status']).to eq 'success'
      expect(json_response['meta']['total_count']).to eq 2
    end
  end
end
