module Payment
  module Gateways
    class AppStore
      def initialize(receipt_data, product: nil, bundle_id: nil, secret_share: nil)
        @receipt_data = receipt_data
        @geteway = Payment::Gateway.new :appstore
        @product = product || @geteway.find_product
        @bundle_id = bundle_id || Dreams.config.appstore_bundle_id
        @secret_share = secret_share || Rails.application.secrets.ios_secret_share
      end

      def processing(dreamer, request_params)
        rate = @product.properties.find_by!(key: 'gateway_rate').value.to_i
        raise ArgumentError, 'Expected positive rate' unless rate > 0

        # TODO: use gateway rate?
        cost = rate

        invoice = @geteway.create_transactions(dreamer, cost).data
        external_transaction = invoice.reason
        @geteway.payment_confirmation(external_transaction, request_params)
      end

      def validate_response(json_data)
        raise ArgumentError, message(json_data['status']) unless json_data['status'].to_i == 0

        bid = json_data['receipt']['bundle_id'] || json_data['receipt']['bid']
        raise ArgumentError, "Unknown application #{bid}" unless @bundle_id == bid

        # TODO: old receipt version
        find_transaction json_data['receipt']['transaction_id']

        product_id = @product.properties.find_by(key: 'apple_product_id').value
        current_receipt = json_data['receipt']['in_app'].detect do |in_app_receipt|
          in_app_receipt['product_id'] == product_id
        end
        raise ArgumentError, 'Unknown inapp receipt' unless current_receipt.present?

        find_transaction current_receipt['transaction_id']

        Result::Success.new json_data
      end

      def find_transaction(transaction_id)
        transaction = ExternalTransaction.find_by(
          external_transaction_id: transaction_id
        )
        raise ArgumentError, 'Double transaction' if transaction.present?
      end

      def validating_receipt_with_appstore
        parameters = {
          'receipt-data': @receipt_data
        }
        parameters['password'] = @secret_share if @secret_share

        receipt_verify = container[:appstore_receipt_verify]
        json_data = receipt_verify.verify parameters

        raise ArgumentError, message(json_data['status']) unless json_data['status'] == 0

        validate_response json_data
      end

      def message(code)
        case code
        when 21_000 then t('errors.appstore.receipt_verify.code_21000')
        when 21_002..21_008 then t("errors.appstore.receipt_verify.code_#{code}")
        else
          "Unknown Error: #{code}"
        end
      end

      def self.save_response(invoice, params)
        params.delete(:controller)
        params.delete(:action)

        invoice.response = params.to_json

        invoice.save
      end
    end
  end
end
