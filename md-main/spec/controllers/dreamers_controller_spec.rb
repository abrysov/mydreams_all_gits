require 'rails_helper'

RSpec.describe DreamersController do
  describe '#facebook' do
    before do
      request.env['omniauth.auth'] = auth_hash
      get :social_login
    end

    context 'when email present' do
      let(:auth_hash) do
        json = JSON.parse(File.read(Rails.root.join('spec/fixtures/facebook_auth_hash.json')))
        OmniAuth.config.mock_auth[:facebook] = json
      end

      it { expect(response).to be_redirect }
      it { expect(controller.signed_in?).to be }
    end

    context 'when email blank' do
      let(:auth_hash) do
        json = JSON.parse(File.read(Rails.root.join('spec/fixtures/facebook_no_email.json')))
        OmniAuth.config.mock_auth[:facebook] = json
      end

      it { expect(response).to be_redirect }
      it { expect(controller.signed_in?).to be }
    end
  end

  describe '#vkontakte' do
    before do
      request.env['omniauth.auth'] = auth_hash
      get :social_login
    end

    context 'when email present' do
      let(:auth_hash) do
        json = JSON.parse(File.read(Rails.root.join('spec/fixtures/vkontakte_auth_hash.json')))
        OmniAuth.config.mock_auth[:vkontakte] = json
      end

      it { expect(response).to be_redirect }
      it { expect(controller.signed_in?).to be }
    end

    context 'when email blank' do
      let(:auth_hash) do
        json = JSON.parse(File.read(Rails.root.join('spec/fixtures/vk_no_email.json')))
        OmniAuth.config.mock_auth[:vkontakte] = json
      end

      it { expect(response).to be_redirect }
      it { expect(controller.signed_in?).to be }
    end
  end

  describe '#instagram' do
    before do
      request.env['omniauth.auth'] = auth_hash
      get :social_login
    end

    context 'when email present' do
      let(:auth_hash) do
        json = JSON.parse(File.read(Rails.root.join('spec/fixtures/instagram_auth_hash.json')))
        OmniAuth.config.mock_auth[:instagram] = json
      end

      it { expect(response).to be_redirect }
      it { expect(controller.signed_in?).to be }
    end
  end

  describe '#create' do
    before { post :create, dreamer: dreamer_params }
    subject { Dreamer.where(email: dreamer_params[:email]) }

    context 'when params are valid' do |variable|
      let(:dreamer_params) {
        {
          email: 'email@mail.com',
          first_name: 'generate(:name)',
          last_name: 'generate(:name)',
          gender: 'male',
          password: 'password',
          terms_of_service: true
        }
      }

      it { is_expected.to exist }
      it { expect(controller.signed_in?).to be }
    end

    context 'when params are invalid' do
      let(:dreamer_params) { {} }

      it { is_expected.not_to exist }
      it { expect(controller.signed_in?).to be false }
    end
  end

  describe 'connect all social to one dreamer' do
    let(:dreamer) { create :dreamer }
    let(:auth_hash_vkontakte) do
      OmniAuth.config.mock_auth[:vkontakte] = json_hash('spec/fixtures/vkontakte_auth_hash.json')
    end
    let(:auth_hash_facebook) do
      OmniAuth.config.mock_auth[:facebook] = json_hash('spec/fixtures/facebook_auth_hash.json')
    end
    let(:auth_hash_instagram) do
      OmniAuth.config.mock_auth[:instagram] = json_hash('spec/fixtures/instagram_auth_hash.json')
    end

    def json_hash(path)
      JSON.parse(File.read(Rails.root.join(path)))
    end

    def all_social_auth
      [auth_hash_vkontakte, auth_hash_facebook, auth_hash_instagram].each do |hash|
        request.env['omniauth.auth'] = hash
        get :social_login
      end
    end

    it 'already signed dreamer connect 3 social providers' do
      sign_in dreamer
      all_social_auth
      expect(dreamer.providers.count).to eq(3)
    end

    it 'new dreamer from social connect 2 other social providers' do
      all_social_auth
      current_dreamer = controller.send(:current_dreamer)
      expect(current_dreamer.providers.count).to eq(3)
    end
  end

  describe 'ios_safe and approved dreamer' do
    let(:approved_dreamer) { create :ios_safe_and_approved_dreamer }
    subject { Dreamer.find(approved_dreamer.id) }
    context 'when sign_in / sign_out' do
      it 'approve and ios_safe has to be unchanged' do
        sign_in approved_dreamer
        sign_out approved_dreamer
        is_expected.to be_ios_safe
        is_expected.to be_approved
      end
    end

    context 'when changing dreamer attributes' do
      it 'has NOT to be ios_safe and approved' do
        attr = %i(first_name last_name status).sample
        subject.update(attr => 'new value')
        is_expected.not_to be_approved
        is_expected.not_to be_ios_safe
      end
    end
    context 'when changing dreamer avatar' do
      it 'has NOT to be ios_safe and approved' do
        attr = :avatar
        subject.update(attr => File.open('spec/fixtures/avatar.jpg', 'rb'))
        is_expected.not_to be_approved
        is_expected.not_to be_ios_safe
      end
    end
  end
end
