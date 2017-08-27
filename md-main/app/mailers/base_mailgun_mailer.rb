class BaseMailgunMailer < ActionMailer::Base
  include BaseMailgunHelpers

  default(
    from: Dreams.config.mail.from,
    reply_to: Dreams.config.mail.reply_to
  )
end
