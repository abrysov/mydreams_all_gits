require 'rails_helper'

RSpec.describe DreamsMailer, type: :mailer do
  describe '.come_true' do
    let(:dreamer) { create :light_dreamer, gender: :male }
    let(:dream) { create :dream, dreamer: dreamer }
    let(:additional_text) { 'additional text' }
    let(:dream_come_true_email) do
      create :dream_come_true_email, dream: dream, additional_text: additional_text
    end

    context 'when dreamer male' do
      it do
        email = described_class.come_true(dream_come_true_email, dreamer.email).deliver_now
        expect(email.html_part.body.to_s).to include I18n.t('mail.male_treatment')
        expect(email.text_part.body.to_s).to include I18n.t('mail.male_treatment')
      end
    end

    context 'when dreamer male' do
      let(:dreamer) { create :light_dreamer, gender: :female }
      it do
        email = described_class.come_true(dream_come_true_email, dreamer.email).deliver_now
        expect(email.html_part.body.to_s).to include I18n.t('mail.female_treatment')
        expect(email.text_part.body.to_s).to include I18n.t('mail.female_treatment')
      end
    end

    context 'when contain additional text' do
      it do
        email = described_class.come_true(dream_come_true_email, dreamer.email).deliver_now
        expect(email.html_part.body.to_s).to include(additional_text)
        expect(email.text_part.body.to_s).to include(additional_text)
      end
    end

    context 'when contain dreamer first name' do
      it do
        email = described_class.come_true(dream_come_true_email, dreamer.email).deliver_now
        expect(email.html_part.body.to_s).to include(dreamer.first_name)
        expect(email.text_part.body.to_s).to include(dreamer.first_name)
      end
    end

    context 'when send right data' do
      it do
        email = described_class.come_true(dream_come_true_email, dreamer.email).deliver_now

        expect(ActionMailer::Base.deliveries.empty?).to eq false
        expect(email.to.first).to eq dreamer.email
        expect(email.from.first).to eq Dreams.config.mail.from
        expect(email.subject).to eq 'Мечта сбылась!'
      end
    end
  end
end
