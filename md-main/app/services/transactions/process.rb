module Transactions
  class Process
    def self.call(transaction)
      new.call(transaction)
    end

    def call(transaction)
      raise ArgumentError, 'Expected Transaction' unless transaction.is_a? ::Transaction
      account = transaction.account

      account.with_lock do
        new_amount = case transaction.operation
                     when 'buy'
                       account.amount - transaction.amount
                     when 'refill'
                       account.amount + transaction.amount
                     end

        if new_amount >= 0
          conclusion(transaction, new_amount)

          Result::Success.new transaction
        else
          failed transaction

          raise NegativeAmountError.new(data: transaction), 'Negative amount'
        end
      end
    end

    protected

    def conclusion(transaction, new_amount)
      account = transaction.account
      account.transaction do
        account.update_attributes(amount: new_amount)
        transaction.to_complete!
        transaction.reason.to_complete!
      end
    end

    def failed(transaction)
      transaction.transaction do
        transaction.to_fail!
        transaction.reason.to_fail!
      end
    end
  end
end
