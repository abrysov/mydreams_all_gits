Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.action_controller.asset_host = '//d20pou9wppyzb1.cloudfront.net'

  ENV['devise.mapping'] = Devise.mappings[:dreamer]

  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.log_level = :info

  config.cache_store = :redis_store, {
    password: Dreams.config.redis.password,
    host: Dreams.config.redis.host,
    port: Dreams.config.redis.port,
    db: Dreams.config.redis.db,
    namespace: Dreams.config.redis.namespace + ':cache',
    expires_in: 1.day
  }
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.action_mailer.default_url_options = { host: 'mydreams.club' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: Dreams.config.mail.smtp,
    port: Dreams.config.mail.port,
    domain: Dreams.config.mail.domain,
    user_name: Dreams.config.mail.user_name,
    password: Dreams.config.mail.password,
    authentication: Dreams.config.mail.authentication,
    enable_starttls_auto: Dreams.config.mail.enable_starttls_auto
  }

  config.active_record.dump_schema_after_migration = false
  config.logstasher.enabled = true
  config.logstasher.suppress_app_log = true
  config.logstasher.backtrace = true
  config.logstasher.logger_path = 'log/production.json.log'

  # no need vew render logs
  class LogStasher::ActionView::LogSubscriber
    def self.attach_to(*args)
    end
  end
end
