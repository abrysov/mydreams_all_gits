class DreamsMailer < ApplicationMailer
  def come_true(come_true_email, email)
    subject = 'Мечта сбылась!'

    dreamer = come_true_email.dream.dreamer
    @name = dreamer.first_name
    @treatment = dreamer.gender == 'male' ? t('mail.male_treatment') : t('mail.female_treatment')
    @additional_text = come_true_email.additional_text
    @snapshot = come_true_email.snapshot

    letter = mail(to: email, subject: subject)
    send_mail(letter, tags: ['come_true_dreams'])
  end
end
