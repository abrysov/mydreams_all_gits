# GOOGLE_API_KEY = 'unuquestring'

module Payments
  module Apple
    class Play
      ISSUER = 'kbsadkb-sadjnais-cheto-tam.apps.googleusercontent.com'.freeze

      # for logging?
      APP_NAME = 'appname'.freeze
      APP_VERSION = '0.1.0'.freeze

      def self.google_api_client
        if ENV['GOOGLE_API_KEY'].nil?
          raise ArgumentError, 'Be sure that you have GOOGLE_API_KEY defined in your environment.'
        end

        parameters = {
          token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
          audience: 'https://accounts.google.com/o/oauth2/token',
          scope: 'https://www.googleapis.com/auth/androidpublisher',
          issuer: ISSUER,
          signing_key: OpenSSL::PKey::RSA.new(ENV['GOOGLE_API_KEY'], 'notasecret')
        }

        @google_client ||= Google::APIClient.new(
          application_name: APP_NAME,
          application_version: APP_VERSION
        ).tap do |client|
          client.authorization = Signet::OAuth2::Client.new parameters
          client.authorization.fetch_access_token!
        end
      end

      def self.test_server(package_name, product_id, token)
        client = google_api_client

        publisher = client.discovered_api('androidpublisher', 'v2')

        # TODO: Ok, dont forget to test
        result = client.execute(
          api_method: publisher.purchases.products.get,
          parameters: { packageName: package_name, productId: product_id, token: token }
        )

        result
      end
    end
  end
end
