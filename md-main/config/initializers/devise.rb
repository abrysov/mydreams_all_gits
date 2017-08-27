Devise.setup do |config|
  config.omniauth :instagram,
    Rails.application.secrets.instagram_key,
    Rails.application.secrets.instagram_secret

  config.omniauth :facebook,
    Rails.application.secrets.facebook_key,
    Rails.application.secrets.facebook_secret

  config.omniauth :twitter,
    Rails.application.secrets.twitter_key,
    Rails.application.secrets.twitter_secret

  config.secret_key = '152cff8e83eb03db05b2d495b656c44f1aadff8897f0ed5bc03e4c41c2dc8ef0ac62c9d696de9589946b62493eea7700e2c11da6190fe6f26c54b55eb55fb5b9'
  config.mailer_sender = Dreams.config.mail.from
  config.mailer = 'DreamerActionMailer'

  require 'devise/orm/active_record'

  config.authentication_keys = [:login]
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.remember_for = 1.day
  config.expire_all_remember_me_on_sign_out = true
  config.expire_auth_token_on_timeout = false
  config.password_length = 4..40
  config.reset_password_within = 6.hours
  config.sign_out_via = [:delete, :get]
  config.allow_unconfirmed_access_for = nil
  config.reconfirmable = true
end

Warden::Manager.after_set_user do |dreamer, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}_id"] = dreamer.id
end

Warden::Manager.before_logout do |dreamer, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}_id"] = nil
end
