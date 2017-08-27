module FriendRequests
  class FriendRequestsFinder
    attr_reader :current_dreamer, :params

    def initialize(scope)
      @scope = scope
    end

    def filter(f = {})
      f[:outgoing] ? outgoing_filter(f) : regular_filter(f)

      @scope
    end

    private

    def outgoing_filter(f)
      @scope = @scope.outgoing_friend_requests
      @scope = @scope.receiver_online                               if f[:online].present?
      @scope = @scope.receiver_vip(f[:vip])                         if f[:vip].present?
      @scope = @scope.receiver_filter_by_gender(f[:gender])         if f[:gender].present?
      @scope = @scope.receiver_filter_by_gender(f[:gender])         if f[:gender].present?
      @scope = @scope.receiver_filter_by_country_id f[:country_id]  if f[:country_id].present?
      @scope = @scope.receiver_filter_by_city_id f[:city_id]        if f[:city_id].present?

      if f[:age].present?
        from = f[:age][:from].present? ? f[:age][:from].to_i : 0
        to = f[:age][:to].present? ? f[:age][:to].to_i : 100

        @scope = @scope.receiver_by_age(from, to)
      end
    end

    def regular_filter(f)
      @scope = @scope.friend_requests
      @scope = @scope.sender_online                                 if f[:online].present?
      @scope = @scope.sender_vip(f[:vip])                           if f[:vip].present?
      @scope = @scope.sender_filter_by_gender(f[:gender])           if f[:gender].present?
      @scope = @scope.sender_filter_by_gender(f[:gender])           if f[:gender].present?
      @scope = @scope.sender_filter_by_country_id f[:country_id]    if f[:country_id].present?
      @scope = @scope.sender_filter_by_city_id f[:city_id]          if f[:city_id].present?

      if f[:age].present?
        from = f[:age][:from].present? ? f[:age][:from].to_i : 0
        to = f[:age][:to].present? ? f[:age][:to].to_i : 100

        @scope = @scope.sender_by_age(from, to)
      end
    end
  end
end
