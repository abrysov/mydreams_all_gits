class ProviderAuth
  attr_reader :auth_hash, :provider_token, :provider_secret, :current_dreamer

  def initialize(auth_hash, current_dreamer = nil)
    @provider_token  = auth_hash.delete(:provider_token)
    @provider_secret = auth_hash.delete(:provider_secret)
    @auth_hash = ActiveSupport::HashWithIndifferentAccess.new(auth_hash)
    @current_dreamer = current_dreamer
  end

  def call
    @auth_hash = new_auth_hash if from_mobile_app?
    provider = find_or_create_provider
    find_or_create_dreamer(provider)
  rescue => exception
    Raven.capture_exception exception
    nil
  end

  def self.call(*args)
    new(*args).call
  end

  private

  def from_mobile_app?
    provider_token.present?
  end

  def find_or_create_provider
    providers = Provider.where(key: auth_hash[:provider], uid: auth_hash[:uid])
    if providers.exists?
      providers.first
    else
      Provider.create(key: auth_hash[:provider], uid: auth_hash[:uid], meta: auth_hash)
    end
  end

  def new_auth_hash
    provider_gateway = SocialNetworks::ProviderGateways::Factory.build(
      provider: auth_hash[:provider],
      token: provider_token,
      secret: provider_secret
    )
    hsh = ActiveSupport::HashWithIndifferentAccess.new(provider_gateway.auth_hash)
    hsh[:email] = auth_hash[:email] if auth_hash[:email]
    hsh
  rescue => e
    Rails.logger.error e.inspect
  end

  def find_or_create_dreamer(provider)
    return provider.dreamer if provider.dreamer

    sn_provider = SocialNetworks::Providers::Factory.build(provider)
    dreamer = current_dreamer || Dreamer.where.not(email: nil).
              where('lower(email) = lower(?)', sn_provider.email).
              first
    if dreamer
      provider.dreamer = dreamer
      provider.save
    else
      ActiveRecord::Base.transaction do
        dreamer = RegisterDreamer.call(
          email: sn_provider.email,
          first_name: sn_provider.first_name,
          last_name: sn_provider.last_name,
          birthday: sn_provider.birthday,
          gender: sn_provider.gender
        )
        dreamer.update(remote_avatar_url: sn_provider.photo) if dreamer
        provider.dreamer = dreamer
        provider.save
      end
    end
    dreamer
  end
end
