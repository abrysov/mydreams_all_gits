module Friends
  class FriendsFinder
    def initialize(scope)
      @scope = scope
    end

    def filter(f = {})
      @scope = @scope.online                              if f[:online].present?
      @scope = @scope.by_vip f[:vip]                      if f[:vip].present?
      @scope = @scope.filter_by_gender f[:gender]         if f[:gender].present?
      @scope = @scope.filter_by_country_id f[:country_id] if f[:country_id].present?
      @scope = @scope.filter_by_city_id f[:city_id]       if f[:city_id].present?

      if f[:age].present?
        from = f[:age][:from].present? ? f[:age][:from].to_i : 0
        to = f[:age][:to].present? ? f[:age][:to].to_i : 100
        @scope = @scope.by_age(from, to)
      end

      @scope
    end
  end
end
