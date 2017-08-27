module Payments
  module Apple
    class Appstore
      def verify(parameters)
        uri = URI Dreams.config.receipt_verify_url

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        request = Net::HTTP::Post.new(uri.request_uri)
        request['Accept'] = 'application/json'
        request['Content-Type'] = 'application/json'
        request.body = parameters.to_json

        apple_response = http.request(request)

        JSON.parse(apple_response.body)
      end
    end
  end
end
