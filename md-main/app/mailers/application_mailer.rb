class ApplicationMailer < ActionMailer::Base
  include BaseMailgunHelpers

  layout 'mailer'

  default(
    from: Dreams.config.mail.from,
    reply_to: Dreams.config.mail.reply_to
  )
end
