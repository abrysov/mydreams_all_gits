module DreamerDeletable
  extend ActiveSupport::Concern

  included do
    default_scope { with_active_dreamer }

    scope :with_removed_dreamer, -> { joins(:dreamer).merge(Dreamer.deleted) }
    scope :with_active_dreamer, -> {
      # пришлось замудренно переписать, иначе возникает ошибка при приджоивании Дримс куда-либо
      # т.к. условие про Дримеров в джоине стоит в запросе раньше, чем сам джоин Дримеров
      d_at  = Dreamer.arel_table

      joins(Arel::Nodes::InnerJoin.new(d_at, Arel::Nodes::On.new(
        self.arel_table[:dreamer_id].eq(d_at[:id])
          .and(Dreamer.not_deleted.where_values)
          .and(Dreamer.not_blocked.where_values)
      )))
    }
  end
end
