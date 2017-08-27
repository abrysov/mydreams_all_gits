module Payments
  module YandexKassa
    class Helpers
      STATUS_CODE = {
        success: 0,
        fail_auth: 1,
        cancel_accept: 100,
        wrong_request: 200
      }.freeze

      def generate_signature(action, params, secret_word)
        return unless action && params && secret_word

        check_string = [
          action,
          params['orderSumAmount'],
          params['orderSumCurrencyPaycash'],
          params['orderSumBankPaycash'],
          params['shopId'],
          params['invoiceId'],
          params['customerNumber'],
          secret_word
        ].join(';')

        Digest::MD5.hexdigest(check_string).upcase
      end

      def check_md5(action, params, secret_word)
        return unless action && params && secret_word

        generate_signature(action, params, secret_word) == params[:md5]
      end

      def build_response(action_name, result_code, invoice_id, shop_id)
        return unless action_name && result_code && invoice_id && shop_id

        performed_data = Time.now.iso8601

        raw_xml = Nokogiri::XML::Builder.new do |xml|
          xml.checkOrderResponse(
            performedDatetime: performed_data,
            code: result_code,
            invoiceId: invoice_id,
            shopId: shop_id
          ) if action_name == 'checkOrder'
          xml.paymentAvisoResponse(
            performedDatetime: performed_data,
            code: result_code,
            invoiceId: invoice_id,
            shopId: shop_id
          ) if action_name == 'paymentAviso'
        end

        raw_xml.to_xml
      end
    end
  end
end
