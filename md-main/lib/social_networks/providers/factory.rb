module SocialNetworks
  module Providers
    class Factory
      def self.build(provider)
        "SocialNetworks::Providers::#{provider.key.camelize}".constantize.new(provider)
      end
    end
  end
end
