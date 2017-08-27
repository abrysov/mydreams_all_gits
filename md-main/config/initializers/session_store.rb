if Rails.env.production?
  Rails.application.config.session_store :cookie_store, key: '_my_dreams_session'
  # :redis_store, {
  #   host: "208.167.236.179",
  #   port: 6379,
  #   db: 0,
  #   namespace: "sessions",
  #   expires_in: 1.day
  # }
else
  Rails.application.config.session_store :cookie_store, key: '_dreams_session'
end
