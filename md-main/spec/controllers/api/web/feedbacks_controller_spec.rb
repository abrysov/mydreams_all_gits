require 'rails_helper'

RSpec.describe Api::Web::FeedbacksController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }

  describe 'GET #index' do
    let(:feedback) { create :feedback }
    let(:dreamer) { feedback.dreamer }
    let(:feedback2) { create :feedback, dreamer: dreamer }
    let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
    let(:schema) { "#{fixture_path}/schema/v1_feedbacks.json" }

    before do
      feedback2
      sign_in dreamer
      get :index
    end

    it { expect(JSON::Validator.validate!(schema, response.body)).to be true }
    it { expect(json_response['feedbacks'].first['id']).to eq feedback2.id }
    it do
      expect(json_response['meta']['status']).to eq 'success'
      expect(json_response['meta']['code']).to eq 200
      expect(json_response['meta']['total_count']).to eq 2
    end
  end
end
