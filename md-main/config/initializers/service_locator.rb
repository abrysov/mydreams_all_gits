require 'service_locator'

ServiceLocator.setup do |config|
  config.mailgun = lambda do
    Dreams.config.service_locator.mailgun.new(
      api_key: Dreams.config.mail.api_key,
      domain: Dreams.config.mail.domain,
      webhook_url: Dreams.config.mail.api_key,
      public_api_key: Dreams.config.mail.public_api_key
    )
  end
end
