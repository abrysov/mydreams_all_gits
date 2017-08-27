Rails.application.configure do
  ENV['devise.mapping'] = Devise.mappings[:dreamer]
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.default_url_options = { host: 'localhost:3009' }

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load

  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true

  config.cache_store = :file_store, "#{Rails.root}/tmp/cache"
  config.web_console.whitelisted_ips = '192.168.0.0/16'
end
