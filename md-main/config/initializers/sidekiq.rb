Sidekiq.configure_server do |config|
  config.redis = {
    password: Dreams.config.redis.password,
    host: Dreams.config.redis.host,
    port: Dreams.config.redis.port,
    db: Dreams.config.redis.db,
    namespace: Dreams.config.redis.namespace
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    password: Dreams.config.redis.password,
    host: Dreams.config.redis.host,
    port: Dreams.config.redis.port,
    db: Dreams.config.redis.db,
    namespace: Dreams.config.redis.namespace
  }
end

if Rails.env.test?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
