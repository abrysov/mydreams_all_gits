class CompetitionsMailer < BaseMailgunMailer
  def fulfilled_dreams(client_email)
    subject = 'Поздравляем Мечтателей! Их Мечты сбылись!'
    letter = mail(to: client_email, subject: subject)

    send_mail(letter, tags: ['fulfilled_dreams', 'notifications'])

    self.message = FakeMailMessage
  end

  def summer(client_email)
    subject = 'Лето с MyDreams.club!'
    letter = mail(to: client_email, subject: subject)

    send_mail(letter, tags: ['summer', 'notifications'])

    self.message = FakeMailMessage
  end
end
