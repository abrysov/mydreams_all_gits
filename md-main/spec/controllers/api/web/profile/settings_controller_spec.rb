require 'rails_helper'

RSpec.describe Api::Web::Profile::SettingsController, type: :controller do
  describe 'POST #change_email' do
    let(:dreamer) { create :dreamer }
    let(:json_response) { JSON.parse(response.body) }

    before do
      sign_in dreamer
      post :change_email, params
      dreamer.reload
    end

    context 'when sended email is blank' do
      let(:params) { { email: '' } }

      it { expect(dreamer.pending_reconfirmation?).to eq false }
      it { expect(response.response_code).to eq 422 }
      it do
        expect(json_response['meta']['code']).to eq 422
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.unprocessable_entity')
      end
    end

    context 'when sended wrong email' do
      let(:params) { { email: '123' } }

      it { expect(dreamer.pending_reconfirmation?).to eq false }
      it { expect(response.response_code).to eq 422 }
      it do
        expect(json_response['meta']['code']).to eq 422
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.unprocessable_entity')
        expect(json_response['meta']['errors']).not_to be_empty
      end
    end

    context 'when success update email' do
      let(:expected_message) { I18n.t('devise.confirmations.send_instructions') }
      let(:params) { { email: 'new@email.com' } }

      it { expect(dreamer.pending_reconfirmation?).to eq true }
      it { expect(dreamer.unconfirmed_email).to eq 'new@email.com' }
      it { expect(response.status).to eq 200 }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq expected_message
      end
    end
  end

  describe 'POST #change_password' do
    let(:dreamer) { create :dreamer }
    let(:json_response) { JSON.parse(response.body) }
    let(:new_password) { 'newpassword123' }

    before do
      sign_in dreamer
      post :change_password, params
      dreamer.reload
    end

    context 'when success update' do
      let(:params) do
        {
          current_password: dreamer.password, password: new_password,
          password_confirmation: new_password
        }
      end
      let(:expected_message) { I18n.t('devise.confirmations.send_instructions') }

      it { expect(dreamer.valid_password?(new_password)).to eq true }
      it { expect(response.status).to eq 200 }
      it do
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
        expect(json_response['meta']['message']).to eq expected_message
      end
    end

    context 'when send wrong current password' do
      let(:params) do
        {
          current_password: '123', password: new_password, password_confirmation: new_password
        }
      end

      it { expect(dreamer.valid_password?(new_password)).to eq false }
      it { expect(response.response_code).to eq 422 }
      it do
        expect(json_response['meta']['code']).to eq 422
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.unprocessable_entity')
      end
    end

    context 'when send wrong password confirmation' do
      let(:params) do
        {
          current_password: dreamer.password, password: new_password, password_confirmation: '123'
        }
      end

      it { expect(dreamer.valid_password?(new_password)).to eq false }
      it { expect(response.response_code).to eq 422 }
      it do
        expect(json_response['meta']['code']).to eq 422
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.unprocessable_entity')
        expect(json_response['meta']['errors']).not_to be_empty
      end
    end

    context 'when send without password' do
      let(:params) { { current_password: dreamer.password, password_confirmation: new_password } }

      it { expect(dreamer.valid_password?(new_password)).to eq false }
      it { expect(response.response_code).to eq 422 }
      it do
        expect(json_response['meta']['code']).to eq 422
        expect(json_response['meta']['status']).to eq 'fail'
        expect(json_response['meta']['message']).to eq I18n.t('api.failure.unprocessable_entity')
        expect(json_response['meta']['errors']).not_to be_empty
      end
    end
  end
end
