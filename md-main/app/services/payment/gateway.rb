module Payment
  class Gateway
    def initialize(gateway, product = nil)
      @gateway = gateway.to_s

      gateways = %w( robokassa appstore )
      raise ArgumentError, 'Unknown payment gateway' unless gateways.include? @gateway

      @product = product || find_product
    end

    def find_product
      products = Product.joins(:properties).
                 where('products.state': :active, 'product_properties.key': :gateway_id,
                       'product_properties.value': @gateway)

      raise ArgumentError, 'No active products' if products.empty?
      raise ArgumentError, 'Several active products' unless products.size == 1

      product = products.first
      raise ArgumentError, "Products for #{@gateway} not found" unless product.present?

      product
    end

    def create_payment(dreamer:, amount:, description: nil)
      status = create_transactions dreamer, amount
      return status unless status.success?

      external_transaction = status.data.reason

      rate = @product.properties.find_by!(key: 'gateway_rate').value.to_i
      raise ArgumentError, 'Expected positive rate' unless rate > 0
      cost = external_transaction.amount * rate

      create_gateway_payment external_transaction, cost, description
    end

    def create_gateway_payment(transaction, cost, description)
      case @gateway
      when 'robokassa'
        Payment::Gateways::Robokassa.create_redirect_url transaction.invoice, cost, description
      when 'appstore'
        # TODO: fix or delete
        transaction
      when 'yandexkassa'
        # TODO: fix it
        raise ArgumentError, 'Unknown payment gateway - add yandexkassa'
      else
        raise ArgumentError, 'Unknown payment gateway'
      end
    end

    def create_transactions(dreamer, amount)
      Payment::Transaction.call(dreamer: dreamer, amount: amount, gateway: @gateway)
    end

    def payment_confirmation(invoice, request_params)
      raise ArgumentError, 'Expected external transaction' unless invoice.is_a? ExternalTransaction
      save_response invoice, request_params

      transaction = ::Transaction.find_by! reason_id: invoice.id
      payment = Transactions::Process.call(transaction)

      if payment.success?
        invoice.to_complete!
        Result::Success.new payment.data
      else
        Result::Error.new 'Invalid purchase'
      end
    end

    def save_response(invoice, request_params)
      case @gateway
      when 'robokassa'
        Payment::Gateways::Robokassa.save_response invoice, request_params
      when 'appstore'
        Payment::Gateways::AppStore.save_response invoice, request_params
      when 'yandexkassa'
        # TODO: fix it
        raise ArgumentError, 'Unknown payment gateway - add yandexkassa'
      else
        raise ArgumentError, 'Unknown payment gateway'
      end
    end
  end
end
