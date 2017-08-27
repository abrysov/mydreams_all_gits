require 'rails_helper'

RSpec.describe ComeTrueEmails::Send do
  describe '.call' do
    let(:sended_email) { SendedMail.first }

    let(:come_true_email) { create :dream_come_true_email }
    let(:sender) { come_true_email.sender }
    let(:dreamer) { come_true_email.dream.dreamer }

    context 'when send email to sender' do
      before do
        @result = described_class.call(come_true_email: come_true_email, test_send_mail: 'true')
      end

      it { expect(@result.success?).to eq true }
      it { expect(@result.data.state).to eq 'tested' }
      it { expect(@result.data.sended_at).not_to be_nil }
      it { expect(Email.first.dreamer).to eq sender }
      it { expect(Email.first.email).to eq sender.email }
      it { expect(sended_email.email).to eq sender.emails.first }
      it { expect(sended_email.dreamer).to eq sender }
    end

    context 'when send email to dream dreamer' do
      before do
        @result = described_class.call(come_true_email: come_true_email, test_send_mail: 'false')
      end

      it { expect(@result.success?).to eq true }
      it { expect(@result.data.state).to eq 'sended' }
      it { expect(@result.data.sended_at).not_to be_nil }
      it { expect(Email.first.dreamer).to eq dreamer }
      it { expect(Email.first.email).to eq dreamer.email }
      it { expect(sended_email.email).to eq dreamer.emails.first }
      it { expect(sended_email.dreamer).to eq dreamer }
      it { expect(@result.data.dream.came_true).to eq true }
      it { expect(@result.data.dream.fulfilled_at).not_to be_nil }
    end

    context 'when send email to dream dreamer multiple times' do
      let(:expect_error) { I18n.t('mailing_list.come_true_dreams.errors.already_send') }
      before do
        @result1 = described_class.call(come_true_email: come_true_email, test_send_mail: 'false')
        @result2 = described_class.call(come_true_email: come_true_email, test_send_mail: 'false')
      end

      it { expect(@result1.success?).to eq true }
      it { expect(@result1.data.state).to eq 'sended' }
      it { expect(@result1.data.sended_at).not_to be_nil }
      it { expect(@result2.success?).to eq false }
      it { expect(@result2.error).to eq expect_error }
    end
  end
end
