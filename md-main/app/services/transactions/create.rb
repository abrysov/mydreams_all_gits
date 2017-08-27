module Transactions
  class Create
    def self.call(amount:, operation:, account:, reason:)
      transaction = Transaction.create(
        amount: amount,
        operation: operation,
        account: account,
        reason: reason
      )

      unless transaction.persisted?
        raise ValidationError.new(errors: transaction.errors), 'Transaction is not verified'
      end

      Result::Success.new transaction
    end
  end
end
