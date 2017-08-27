module Payments
  module YandexKassa
    class Api
      def pay_redirect_location(url, post_params)
        return unless url && post_params

        uri = URI.parse(url)
        response = Net::HTTP.post_form(uri, post_params)
        response['location'] if response.is_a? Net::HTTPRedirection
      end
    end
  end
end
