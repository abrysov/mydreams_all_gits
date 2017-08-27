require 'rails_helper'

RSpec.describe Api::Web::SearchController, type: :controller do
  describe 'GET #index, search with search_type' do
    let(:json_response) { JSON.parse(response.body) }
    let(:dream_schema) { "#{fixture_path}/schema/v1_dreams.json" }
    let(:dreamer_schema) { "#{fixture_path}/schema/v1_dreamers.json" }
    let(:post_schema) { "#{fixture_path}/schema/v1_posts.json" }

    def response_entity_ids(type)
      json_response[type + 's'].map { |x| x['id'] }
    end

    describe 'search' do
      let!(:target_dream)     { create :dream, title: 'xxx' }
      let!(:target_dreamer)   { create :dreamer, first_name: 'xxx' }
      let!(:target_post)      { create :post, title: 'xxx', content: 'xxx' }
      let!(:unwanted_dream)   { create :dream, title: 'yyy' }
      let!(:unwanted_dreamer) { create :dreamer, first_name: 'yyy' }
      let!(:unwanted_post)    { create :post, title: 'yyy', content: 'yyy' }
      let(:dream_ids) { response_entity_ids('dream') }
      let(:dreamer_ids) { response_entity_ids('dreamer') }
      let(:post_ids) { response_entity_ids('post') }

      before { get :index, q: 'xxx' }

      it 'dreams schema ok' do
        expect(JSON::Validator.validate!(dream_schema, response.body)).to be true
      end

      it 'dreamers schema ok' do
        expect(JSON::Validator.validate!(dreamer_schema, response.body)).to be true
      end

      it 'posts schema ok' do
        expect(JSON::Validator.validate!(post_schema, response.body)).to be true
      end

      it 'should include only target dream' do
        expect(dream_ids).to include(target_dream.id)
        expect(dream_ids).not_to include(unwanted_dream.id)
      end

      it 'should include only target dreamer' do
        expect(dreamer_ids).to include(target_dreamer.id)
        expect(dreamer_ids).not_to include(unwanted_dreamer.id)
      end

      it 'should include only target post' do
        expect(post_ids).to include(target_post.id)
        expect(post_ids).not_to include(unwanted_post.id)
      end
    end
  end
end
