module Purchasing
  class Create
    def self.call(dreamer:, destination: nil, product:, destination_dreamer: nil, comment: nil, quantity: 1)
      raise ArgumentError, 'Expected that the product will be active' unless product.active?
      raise ArgumentError, 'Expected not nil destination' if destination.nil? && !product.special?

      destination_dreamer ||= dreamer
      cost = product.cost * quantity

      purchase = Purchase.create(dreamer: dreamer, amount: cost, product: product,
                                 destination_dreamer: destination_dreamer, destination: destination,
                                 comment: comment)

      unless purchase.persisted?
        raise ValidationError.new(errors: purchase.errors), 'Purchase is not verified'
      end

      Result::Success.new purchase
    end
  end
end
