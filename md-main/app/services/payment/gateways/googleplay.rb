module Payment
  module Gateways
    class GooglePlay
      def initialize(receipt_data, product: nil, bundle_id: nil)
        @receipt_data = receipt_data
        @geteway = Payment::Gateway.new :googleplay
        @product = product || @geteway.find_product
        @bundle_id = bundle_id || Dreams.config.appstore_bundle_id
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
        raise ArgumentError, 'create validate response'
      end

      def find_transaction(transaction_id)
        transaction = ExternalTransaction.find_by(
          external_transaction_id: transaction_id
        )
        raise ArgumentError, 'Double transaction' if transaction.present?
      end

      def validating_receipt_with_googleplay
        # request params
        parameters = {}
        # send request to google api - use DI container
        receipt_verify = container[:appstore_receipt_verify]
        json_data = receipt_verify.verify parameters

        # validate status
        raise ArgumentError, message(json_data['status']) unless json_data['status'] == 0

        validate_response json_data
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
