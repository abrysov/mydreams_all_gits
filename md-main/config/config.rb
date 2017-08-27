# Rails.root are not initialized here
app_path = File.expand_path('../../', __FILE__)

config_path = File.join(app_path, 'config', 'dreams.default.yml')
override_config_path = File.join(app_path, 'config', 'dreams.yml')

secret_config_path = File.join(app_path, 'config', 'dreams_secrets.default.yml')
override_secret_config_path = File.join(app_path, 'config', 'dreams_secrets.yml')

Persey.init Rails.env do # set current environment
  source :yaml, config_path
  source :yaml, override_config_path
  source :yaml, secret_config_path, :secret
  source :yaml, override_secret_config_path, :secret

  env :default do
    service_locator do
      mandrill -> { Mandrill::API }
      mailgun -> { Mailgun::Base }
    end
    # declare here some config option for all environments
    appstore_bundle_id -> { 'club.mydreams.MyDreams' }
    receipt_verify_url -> { 'https://sandbox.itunes.apple.com/verifyReceipt' }
  end

  env :production, parent: :default do
    # redeclare here some specific keys for production environment
    receipt_verify_url -> { 'https://buy.itunes.apple.com/verifyReceipt' }
  end

  env :development, parent: :production do
    # redeclare here some specific keys for development environment
  end

  env :staging, parent: :production do
    # redeclare here some specific keys for staging environment
  end

  env :test, parent: :development do
    service_locator do
      mandrill -> { Test::Mandrill::API }
      mailgun -> { Test::Mailgun::Base }
    end
  end
end

# Define method in Dreams
module Dreams
  def self.config
    Persey.config
  end
end
