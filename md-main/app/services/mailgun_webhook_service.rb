class MailgunWebhookService
  require 'openssl'

  def initialize(event, params)
    @event = event
    @params = params
  end

  def process_event
    unless verify
      Rails.logger.error('request from mailgun_webhook unverifed')
      return false
    end

    email = SendedMail.find_by(external_id: message_id).try(:email)
    if email
      update_email(email, @event)
    else
      Rails.logger.error('Mailgun - webhook Email not found')
    end
    true
  end

  def self.process_event(*args)
    new(*args).process_event
  end

  private

  def verify
    digest = OpenSSL::Digest::SHA256.new
    data = [timestamp, token].join
    signature == OpenSSL::HMAC.hexdigest(digest, api_key, data)
  end

  def update_email(email, event)
    case event
    when 'complained'
      email.update spam: true
    when 'unsubscribed'
      email.update unsub: true
    when 'bounced'
      email.update hard_bounce: true
    end
  end

  %w(timestamp token signature).each do |action|
    define_method(action) do
      @params[action]
    end
  end

  def message_id
    @params['Message-Id']
  end

  def api_key
    Dreams.config.mail.api_key
  end
end
