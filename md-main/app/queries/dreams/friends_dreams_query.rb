module Dreams
  class FriendsDreamsQuery
    attr_accessor :dreamer

    def initialize(dreamer)
      @dreamer = dreamer
    end

    def call
      Dream.all_for(dreamer).where(where_condition).order(created_at: :desc)
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def where_condition
      "
      dreamer_id = ANY(
        select distinct(unnest(member_ids)) AS dreamer_id
        FROM friendships
        WHERE member_ids @> ARRAY[#{dreamer.id}])
      AND dreamer_id <> #{dreamer.id}
      "
    end
  end
end
