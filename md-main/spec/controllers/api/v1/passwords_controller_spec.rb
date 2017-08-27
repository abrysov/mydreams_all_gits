require 'rails_helper'

RSpec.describe Api::V1::PasswordsController, type: :controller do
  let(:json) { JSON.parse(subject.body) }
  describe 'POST #reset' do
    context 'isset dreamer' do
      let(:dreamer) { create(:light_dreamer) }
      subject { post :reset, email: dreamer.email }

      it do
        expect(subject.content_type).to eq 'application/json'
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['message']).to eq I18n.t('devise.confirmations.send_instructions')
        expect(json['meta']['status']).to eq 'success'
      end
    end

    context 'unknow email' do
      subject { post :reset, email: 'unknow@email' }

      it do
        expect(subject.content_type).to eq 'application/json'
        expect(json['meta']['code']).to eq 400
        expect(json['meta']['message']).to eq I18n.t('devise.confirmations.instructions_not_sent')
        expect(json['meta']['status']).to eq 'fail'
      end
    end
  end
end
