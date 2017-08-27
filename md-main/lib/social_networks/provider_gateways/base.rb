module SocialNetworks
  module ProviderGateways
    class Base
      def initialize(token, secret=nil)
        @token  = token
        @secret = secret
      end

      def uri_json_response(social_uri)
        uri = URI.parse(social_uri)
        response = Net::HTTP.get_response(uri)
        res = JSON.parse(response.body)

        raise Errors::WrongCredintails if res['error'].present?
        res
      end
    end
  end
end
