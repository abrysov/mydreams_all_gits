module Purchasing
  class Transaction
    def self.call(purchase:, operation:, transfer_refill: false)
      raise ArgumentError, 'Expected Purchase' unless purchase.is_a? Purchase

      account = transfer_refill ? purchase.destination_dreamer.account : purchase.dreamer.account

      payment = PurchaseTransaction.create(
        account: account,
        operation: operation,
        amount: purchase.amount,
        purchase: purchase
      )

      unless payment.persisted?
        raise ValidationError.new(errors: payment.errors), 'Purchase Transaction is not verified'
      end

      transaction = Transactions::Create.call(
        account: account,
        operation: operation,
        amount: payment.amount,
        reason: payment
      ).data

      unless transaction.persisted?
        raise ValidationError.new(errors: transaction.errors), 'Transaction is not verified'
      end

      Result::Success.new transaction
    end
  end
end
