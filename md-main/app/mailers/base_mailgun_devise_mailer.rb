class BaseMailgunDeviseMailer < Devise::Mailer
  # include Devise::Controllers::UrlHelpers
  include BaseMailgunHelpers

  default(
    # template_path: 'devise/mailer',
    from: Dreams.config.mail.from,
    reply_to: Dreams.config.mail.reply_to
  )
end
