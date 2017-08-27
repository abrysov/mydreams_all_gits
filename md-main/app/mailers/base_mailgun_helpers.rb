module BaseMailgunHelpers
  private

  def send_mail(letter, opts = {})
    # https://github.com/HashNuke/mailgun/blob/master/lib/mailgun/message.rb#L10-L17
    parameters = {
      to: letter.to,
      subject: letter.subject,
      text: letter.text_part.body.to_s,
      html: letter.html_part.body.to_s,
      from: "#{Dreams.config.mail.from_name} <#{Dreams.config.mail.from}>"
    }
    parameters[:tags] = opts[:tags] if opts[:tags]

    message = mailgun.messages.send_email parameters
    store_mail(letter, message)
  end

  def store_mail(letter, message)
    dreamer_email = Email.find_by(email: letter.to)
    if dreamer_email
      SendedMail.create(
        external_id: message['id'],
        email_id: dreamer_email.id,
        dreamer_id: dreamer_email.dreamer.id,
        subject: letter.subject,
        body: letter.html_part.body.to_s,
        format: :html
      )
    end
  end

  def mailgun
    @mailgun ||= ServiceLocator.mailgun
  end
end
