require 'rails_helper'

RSpec.describe Admin::MailingList::ComeTrueDreamsController, type: :controller do
  let(:sender) { create :light_dreamer }
  before { sign_in sender }

  describe 'PUT #update' do
    let(:dream_come_true_email) { create :dream_come_true_email }

    context 'when success update' do
      let(:expected_path) { admin_mailing_list_come_true_dream_path(id: dream_come_true_email.id) }
      before do
        put :update, id: dream_come_true_email.id, additional_text: '123', snapshot_type: 'dream'
        dream_come_true_email.reload
      end

      it { expect(dream_come_true_email.additional_text).to eq '123' }
      it { expect(dream_come_true_email.snapshot.present?).to eq true }
      it { expect(response).to redirect_to expected_path }
    end
  end

  describe 'GET #search' do
    context 'when success search' do
      let(:dream) { create :dream }
      let(:dream_come_true_email) { DreamComeTrueEmail.last }
      let(:expected_path) do
        edit_admin_mailing_list_come_true_dream_path(id: dream_come_true_email.id)
      end
      before { get :search, search: dream.id }

      it { expect(dream_come_true_email).not_to be_nil }
      it { expect(response).to redirect_to expected_path }
    end

    context 'when failed search' do
      let(:dream) { create :dream, came_true: true }
      let(:expected_flash) { I18n.t('mailing_list.come_true_dreams.errors.already_come_true') }
      before { get :search, search: dream.id }

      it { expect(flash[:alert]).to eq expected_flash }
      it { expect(response).to render_template 'mailing_list/come_true_dreams/search' }
    end
  end

  describe 'GET #send_mail' do
    context 'when success send test email' do
      let(:come_true) do
        create(:dream_come_true_email, sender: sender, state: :pending)
      end
      let(:expected_path) { admin_mailing_list_come_true_dream_path(id: come_true.id) }

      before do
        get :send_mail, come_true_email_id: come_true.id, additional_text: 'xxx',
                        test_send_mail: true
      end

      it { expect(response).to redirect_to expected_path }
      it { expect(flash[:success]).to eq I18n.t('mailing_list.come_true_dreams.success.mail_sent') }
    end

    context 'when success send email' do
      let(:come_true) do
        create(:dream_come_true_email, sender: sender, state: :pending)
      end
      let(:dream) { create :dream }
      let(:expected_path) { admin_mailing_list_come_true_dream_path(id: come_true.id) }
      before do
        get :send_mail, come_true_email_id: come_true.id, additional_text: 'xxx',
                        test_send_mail: false
      end

      it { expect(response).to redirect_to expected_path }
      it { expect(flash[:success]).to eq I18n.t('mailing_list.come_true_dreams.success.mail_sent') }
    end

    context 'when dream already come true' do
      let(:dream) { create :dream, came_true: true }
      let(:come_true) do
        create(:dream_come_true_email, sender: sender, state: :pending, dream: dream)
      end
      let(:expected_flash) { I18n.t('mailing_list.come_true_dreams.errors.already_come_true') }
      before do
        get :send_mail, come_true_email_id: come_true.id, additional_text: 'xxx',
                        test_send_mail: false
      end

      it { expect(response).to redirect_to admin_mailing_list_root_path }
      it { expect(flash[:alert]).to eq expected_flash }
    end

    context 'when mail already sent' do
      let(:come_true) do
        create(:dream_come_true_email, sender: sender, state: :sended,
                                       sended_at: Time.zone.now)
      end
      before do
        get :send_mail, come_true_email_id: come_true.id, additional_text: 'xxx',
                        test_send_mail: false
      end

      it { expect(response).to redirect_to admin_mailing_list_root_path }
      it { expect(flash[:alert]).to eq I18n.t('mailing_list.come_true_dreams.errors.already_send') }
    end
  end
end
