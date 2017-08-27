module Purchasing
  class Process
    def self.call(purchase, operation = 'buy', transfer_refill = false)
      raise ArgumentError, 'Expected Purchase' unless purchase.is_a? Purchase
      purchase.to_processing! unless transfer_refill

      transaction = Purchasing::Transaction.call(purchase: purchase,
                                                 operation: operation,
                                                 transfer_refill: transfer_refill)

      raise ArgumentError, 'Negative amount' unless transaction.success?

      buy(purchase, transaction.data, transfer_refill)
    end

    def self.buy(purchase, transaction, transfer_refill)
      raise ArgumentError, 'Expected Purchase' unless purchase.is_a? Purchase
      raise ArgumentError, 'Expected Transaction' unless transaction.is_a? ::Transaction
      raise ArgumentError, 'Expected active product' unless purchase.product.active?

      payment = Transactions::Process.call(transaction)
      if payment.success? && transaction.complete?
        purchase.to_complete! unless transfer_refill
        Result::Success.new payment.data
      else
        Result::Error.new 'Invalid purchase'
      end
    end
  end
end
