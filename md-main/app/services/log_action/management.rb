module LogAction
  class Management
    def initialize(action, product, admin)
      @action = action
      @product = product
      @admin = admin
    end

    def call
      ManagementLog.create(
        action: @action,
        logable: @product,
        dreamer: @admin
      )
    end

    def self.call(*args)
      new(*args).call
    end
  end
end
