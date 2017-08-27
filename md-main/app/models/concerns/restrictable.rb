module Restrictable
  extend ActiveSupport::Concern

  module ClassMethods
    def restriction_levels
      I18n.t('restriction_levels')
    end

    def restriction_levels_for_select
      restriction_levels.each_with_index.map { |l, i| [l, i] }
    end

    def all_for(current_dreamer, with_mine = false)
      queries = queries_for(current_dreamer)
      if with_mine && current_dreamer.present?
        queries = queries.or(arel_table[:dreamer_id].eq(current_dreamer.id))
      end
      where(queries)
    end

    def queries_for(current_dreamer)
      queries = arel_table[:restriction_level].eq(0)

      if current_dreamer.present?
        queries = queries.or(
          arel_table[:restriction_level].eq(1).and(
            arel_table[:dreamer_id].in(Arel.sql(current_dreamer.friends.select(:id).to_sql)).
            or(arel_table[:dreamer_id].eq(current_dreamer.id))
          )
        )

        queries = queries.or(
          arel_table[:restriction_level].eq(2).and(arel_table[:dreamer_id].eq(current_dreamer.id))
        )
      end

      queries
    end
  end
end
