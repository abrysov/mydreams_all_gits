module Purchases
  class Purchases
    attr_reader :params, :scope

    def initialize(params, scope = nil)
      @params = params
      @scope = scope || Purchase
    end

    def fetch
      # TODO: use scope?
      @scope = @scope.order(id: :desc)
      filter
    end

    def management
      # TODO: use scope?
      @scope = @scope.order(updated_at: :desc)
      filter
    end

    def filter
      @scope = @scope.completed     if @params[:completed].present?
      @scope = @scope.failed        if @params[:failed].present?
      @scope = @scope.in_processing if @params[:processing].present?
      @scope
    end

    def self.fetch(*args)
      new(*args).fetch
    end

    def self.management(*args)
      new(*args).management
    end
  end
end
