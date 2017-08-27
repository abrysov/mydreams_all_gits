module Dreams
  class DreamsFinder
    def initialize(scope = nil)
      @scope = scope || Dream
    end

    def filter(filter_params, dreamer, for_dreamer = false)
      @scope = @scope.all_for(dreamer, for_dreamer).not_deleted.ordinary_dreams
      if filter_params[:from].present?
        @scope = @scope.where('dreams.id >= :from', from: filter_params[:from]).order(id: :asc)
      end
      if %w( male female ).include?(filter_params[:gender])
        @scope = @scope.joins(:dreamer).where(dreamer: { gender: filter_params[:gender] })
      end
      @scope = @scope.fulltext_search(filter_params[:search]) if filter_params[:search].present?
      @scope = @scope.
               came_true(filter_params[:fulfilled]).
               order(fulfilled_at: :desc)                     if filter_params[:fulfilled].present?
      @scope = @scope.order(comments_count: :desc)            if filter_params[:hot].present?
      @scope = @scope.order(created_at: :desc)                if filter_params[:new].present?
      @scope = @scope.order(likes_count: :desc)               if filter_params[:liked].present?
      @scope = @scope.order(launches_count: :desc)            if filter_params[:launches].present?
      @scope
    end
  end
end
