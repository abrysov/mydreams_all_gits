module Payment
  class Transaction
    def self.call(dreamer:, amount:, gateway:, operation: 'refill')
      # TODO: relation to ExternalTransaction?
      invoice = Invoice.create dreamer: dreamer, amount: amount

      unless invoice.persisted?
        raise ValidationError.new(errors: invoice.errors), 'Invoice has not been verified'
      end

      external = ExternalTransaction.create(account: dreamer.account, operation: operation,
                                            amount: amount, gateway_id: gateway, invoice: invoice)

      unless external.persisted?
        raise ValidationError.new(errors: external.errors), 'External Transaction is not verified'
      end

      invoice.payable = external
      invoice.save

      transaction = Transactions::Create.call(
        account: external.account, reason: external,
        operation: external.operation, amount: external.amount
      ).data

      unless transaction.persisted?
        raise ValidationError.new(errors: transaction.errors), 'Transaction is not verified'
      end

      Result::Success.new transaction
    end
  end
end
