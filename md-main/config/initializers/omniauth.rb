Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
    Rails.application.secrets.facebook_key,
    Rails.application.secrets.facebook_secret,
    callback_path: '/facebook_callback',
    scope: 'email,public_profile,user_friends'

  provider :twitter,
    Rails.application.secrets.twitter_key,
    Rails.application.secrets.twitter_secret,
    callback_path: '/twitter_callback'

  provider :instagram,
    Rails.application.secrets.instagram_key,
    Rails.application.secrets.instagram_secret,
    callback_path: '/instagram_callback'

  provider :vkontakte,
    Rails.application.secrets.vkontakte_key,
    Rails.application.secrets.vkontakte_secret,
    callback_path: '/vkontakte_callback',
    scope: 'email'
end

OmniAuth.config.on_failure = Proc.new do |env|
  env['devise.mapping'] = Devise.mappings[:dreamer]
  controller_name  = ActiveSupport::Inflector.camelize(env['devise.mapping'].controllers[:omniauth_callbacks])
  controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
  controller_klass.action(:failure).call(env)
end
