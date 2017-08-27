class DreamerActionMailer < BaseMailgunDeviseMailer
  def confirmation_instructions(dreamer, token, opts)
    @dreamer = dreamer.decorate
    @token = token
    @subject = I18n.t(:dreamer_subject, scope: [:devise, :mailer, :confirmation],
                      default: [:subject, 'confirmation'.humanize])

    email = if dreamer.confirmed?
              dreamer.email || dreamer.unconfirmed_email
            else
              dreamer.unconfirmed_email.blank? ? dreamer.email : dreamer.unconfirmed_email
            end

    letter = mail(to: email, subject: @subject)
    send_mail(letter, tags: ['confirmation_instructions'])
    self.message = FakeMailMessage
  end

  def reset_password_instructions(dreamer, token, opts)
    @dreamer = dreamer.decorate
    @token = token
    @subject = I18n.t(:reset_password_subject, scope: [:devise, :mailer, :reset_password],
                      default: [:subject, 'reset_password'.humanize])

    email = dreamer.email || dreamer.unconfirmed_email
    letter = mail(to: email, subject: @subject)
    send_mail(letter, tags: ['reset_password_instructions'])
    self.message = FakeMailMessage
  end
end
