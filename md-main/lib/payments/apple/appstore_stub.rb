module Payments
  module Apple
    class AppstoreStub
      def verify(_parameters)
        JSON.parse File.open("#{::Rails.root}/spec/fixtures/appstore_result.json", 'rb').read
      end
    end
  end
end
