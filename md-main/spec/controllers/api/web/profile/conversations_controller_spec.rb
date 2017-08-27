require 'rails_helper'

RSpec.describe Api::Web::Profile::ConversationsController, type: :controller do
  describe 'GET #index' do
    let(:dreamer) { create(:light_dreamer) }
    let(:json) { JSON.parse(subject.body) }
    let(:schema) { "#{fixture_path}/schema/v1_profile_conversations.json" }

    context 'dreamer conversations' do
      before do
        create(:message, receiver: dreamer)
        sign_in dreamer
      end

      subject { get :index }

      it { is_expected.to have_http_status 200 }
      it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
      it do
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
        expect(json['conversations'].count).to eq 1
      end
    end

    context '403' do
      subject { get :index }

      it { is_expected.to have_http_status 403 }
    end
  end

  describe 'create conversation' do
    let(:dreamer) { create(:light_dreamer) }
    let(:to_dreamer) { create(:light_dreamer) }
    let(:json) { JSON.parse(subject.body) }
    let(:schema) { "#{fixture_path}/schema/v1_profile_create_conversation.json" }

    context 'to dreamer' do
      before do
        sign_in dreamer
      end

      subject { post :create, id: to_dreamer.id }

      it { is_expected.to have_http_status 200 }
      it { expect(JSON::Validator.validate!(schema, subject.body)).to be true }
      it do
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
      end
    end

    context '403' do
      subject { post :create }

      it { is_expected.to have_http_status 403 }
      it do
        expect(json['meta']['code']).to eq 403
        expect(json['meta']['status']).to eq 'fail'
      end
    end

    context 'to unknow dreamer' do
      before do
        sign_in dreamer
      end

      subject { post :create, id: 0 }

      it { is_expected.to have_http_status 404 }
      it do
        expect(json['meta']['code']).to eq 404
        expect(json['meta']['status']).to eq 'fail'
      end
    end
  end
end
