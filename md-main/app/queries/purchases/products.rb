module Purchases
  class Products
    attr_reader :params, :scope

    def initialize(params, scope = nil)
      @params = params
      @scope = scope || Product
    end

    def fetch
      @scope = @scope.active
      filter
    end

    def management
      filter
    end

    def filter
      @scope = @scope.certificates if @params[:certificates].present?
      @scope = @scope.vip_statuses if @params[:vip_statuses].present?
      @scope = @params[:special].present? ? @scope.special : @scope.without_special
      @scope.preload(:properties)
      @scope
    end

    def inapp(gateway)
      @scope = @scope.joins(:properties).
               where('products.state': :active, 'product_properties.key': :gateway_id,
                     'product_properties.value': gateway)
    end

    def self.fetch(*args)
      new(*args).fetch
    end

    def self.management(*args)
      new(*args).management
    end

    def self.inapp(gateway)
      new({}).inapp gateway
    end
  end
end
