module Buy
  class Coins
    def initialize(gateway)
      @gateway = gateway.to_s
    end

    def create(dreamer:, amount:)
      payment_gateway = Payment::Gateway.new @gateway
      description = I18n.t('payments.description')

      payment_gateway.create_payment dreamer: dreamer, amount: amount, description: description
    end

    class << self
      def transfer(dreamer:, destination_dreamer:, product:, quantity:)
        unless product.special?
          raise ArgumentError, 'Expected that the product will be special (coins)'
        end

        purchase = Purchasing::Create.call(dreamer: dreamer, product: product,
                                           destination_dreamer: destination_dreamer,
                                           quantity: quantity)

        return Result::Error.new purchase unless purchase.success?

        @purchase = purchase.data
        processing
      end

      def processing
        raise ArgumentError, 'Wrong product' unless @purchase.product.special?
        transaction = Purchasing::Process.call(@purchase, :buy)

        return Result::Error.new transaction unless transaction.success?
        create_coin_refill_transactions(@purchase)
      end

      def create_coin_refill_transactions(purchase)
        transfer_refill = true
        Purchasing::Process.call(purchase, :refill, transfer_refill)
      end
    end
  end
end
