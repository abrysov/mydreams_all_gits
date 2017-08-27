module SocialNetworks
  module ProviderGateways
    class Factory
      def self.build(provider:, token:, secret: nil)
        "SocialNetworks::ProviderGateways::#{provider.to_s.camelize}".constantize.new(token, secret)
      end
    end
  end
end
