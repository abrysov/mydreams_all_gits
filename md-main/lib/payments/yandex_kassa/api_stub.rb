module Payments
  module YandexKassa
    class ApiStub
      def pay_redirect_location(_url, _post_params)
        '/test'
      end
    end
  end
end
