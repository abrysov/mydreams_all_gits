module Dreamers
  class DreamersFinder
    def initialize(scope = nil)
      @scope = scope || Dreamer
    end

    def filter(f = {})
      if f[:from].present?
        @scope = @scope.where('dreamers.id >= :from', from: f[:from]).order(id: :asc)
      end
      if f[:age].present?
        from = f[:age][:from].present? ? f[:age][:from].to_i : 0
        to = f[:age][:to].present? ? f[:age][:to].to_i : 100
        @scope = @scope.by_age(from, to)
      end
      @scope = @scope.by_birthday(f[:birthday])            if f[:birthday].present?
      @scope = @scope.fulltext_search(f[:search])          if f[:search].present?
      @scope = @scope.online                               if f[:online].present?
      @scope = @scope.by_vip(f[:vip])                      if f[:vip].present?
      @scope = @scope.celebrities                          if f[:celebrities].present?
      @scope = @scope.filter_by_gender(f[:gender])         if f[:gender].present?
      @scope = @scope.filter_by_age(f[:age_range])         if f[:age_range].present?
      @scope = @scope.filter_by_country_id(f[:country_id]) if f[:country_id].present?
      @scope = @scope.filter_by_city_id(f[:city_id])       if f[:city_id].present?
      @scope = @scope.order(id: :desc)                     if f[:new].present?
      @scope = @scope.by_visits_count                      if f[:top].present?
      @scope
    end
  end
end
