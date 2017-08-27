module Visitable
  extend ActiveSupport::Concern

  included do
    has_many :passive_visits, class_name: 'Visit', foreign_key: :visited_id
    has_many :visited_by, through: :passive_visits, class_name: 'Dreamer', source: :visitor

    has_many :active_visits, class_name: 'Visit', foreign_key: :visitor_id
    has_many :i_visited, through: :active_visits, class_name: 'Dreamer', source: :visited

    attr_accessor :last_unviewed_dreams, :nb_unviewed_dreams
  end


  module ClassMethods
    def preload_last_unviewed_dreams(collection)
      last_unviewed_dreams = fetch_last_unviewed_dreams(collection)

      collection.each do |owner|
        owner.last_unviewed_dreams, last_unviewed_dreams = last_unviewed_dreams.partition { |d| d.dreamer_id == owner.id }
      end
    end

    def preload_nb_unviewed_dreams(collection)
      nb_unviewed_dreams = fetch_nb_unviewed_dreams(collection)

      collection.each do |owner|
        owner.nb_unviewed_dreams = nb_unviewed_dreams.collect { |id, nb| nb if id == owner.id }.first
      end
    end

    private

    def fetch_last_unviewed_dreams(collection, limit = 3)
      ds = Dream.arel_table
      dv = Visit.arel_table

      sub_ds = ds.project(Arel.star).as('sub_ds')

      Dream.joins(
        Arel::Nodes::InnerJoin.new(sub_ds, Arel::Nodes::On.new(
            sub_ds[:dreamer_id].eq(ds[:dreamer_id])
            .and(sub_ds[:id].gteq(ds[:id]))
          ))
        )
        .joins(Arel::Nodes::OuterJoin.new(dv, Arel::Nodes::On.new(ds[:dreamer_id].eq(dv[:visited_id]))))
        .where(ds[:dreamer_id].in(collection.map(&:id)))
        .where(Arel::Nodes::SqlLiteral.new("
          CASE WHEN #{dv[:visited_id].not_eq(nil).to_sql}
            THEN #{ds[:created_at].gt(dv[:updated_at]).to_sql}
            ELSE true
          END
        "))
        .group(ds[:id])
        .having("COUNT(*) <= #{limit}")
        .order([ds[:dreamer_id], ds[:id].desc])
    end

    def fetch_nb_unviewed_dreams(collection)
      ds = Dream.arel_table
      dv = Visit.arel_table

      Dream.joins(Arel::Nodes::OuterJoin.new(dv, Arel::Nodes::On.new(ds[:dreamer_id].eq(dv[:visited_id]))))
        .where(ds[:dreamer_id].in(collection.map(&:id)))
        .where(Arel::Nodes::SqlLiteral.new("
          CASE WHEN #{dv[:visited_id].not_eq(nil).to_sql}
            THEN #{ds[:created_at].gt(dv[:updated_at]).to_sql}
            ELSE true
          END
        "))
        .group(ds[:dreamer_id])
        .order(ds[:dreamer_id])
        .count
    end
  end


  def friends_with_unviewed_dreams
    return Dreamer.none if (ids = friends.pluck(:id)).empty?

    dr = Dreamer.arel_table
    dv = Visit.arel_table
    ds_sub1 = Arel::Table.new(Dream.table_name, as: 'd1')
    ds_sub2 = Dream.arel_table

    join_dv = dr.join(dv, Arel::Nodes::OuterJoin).on(
      dr[:id].eq(dv[:visited_id]).and(dv[:visitor_id].eq(self.id))
    )

    sub_ds = ds_sub1.project(Arel.star).where(ds_sub1[:id].in(
      ds_sub2.project(ds_sub2[:id].maximum()).where(ds_sub2[:dreamer_id].in(ids)).group(ds_sub2[:dreamer_id])
    )).as('sub_ds')

    join_ds = dr.join(sub_ds, Arel::Nodes::InnerJoin).on(
      Arel::Nodes::SqlLiteral.new("
        CASE WHEN #{dv[:visited_id].not_eq(nil).to_sql}
          THEN #{sub_ds[:dreamer_id].eq(dr[:id]).and(sub_ds[:created_at].gt(dv[:updated_at])).to_sql}
          ELSE #{sub_ds[:dreamer_id].eq(dr[:id]).to_sql}
        END
      "))

    Dreamer.not_deleted.joins([join_dv.join_sources, join_ds.join_sources]).order(sub_ds[:created_at].desc)
  end

  def nb_unviewed_friends_dreams
    return nil if (ids = friends.map(&:id)).empty?

    ds = Dream.arel_table
    dv = Visit.arel_table

    Dream.joins(Arel::Nodes::OuterJoin.new(dv, Arel::Nodes::On.new(
        ds[:dreamer_id].eq(dv[:visited_id])
        .and(dv[:visitor_id].eq(self.id))
      )))
      .where(ds[:dreamer_id].in(ids))
      .where(Arel::Nodes::SqlLiteral.new("
        CASE WHEN #{dv[:visited_id].not_eq(nil).to_sql}
          THEN #{ds[:created_at].gt(dv[:updated_at]).to_sql}
          ELSE true
        END
      "))
      .count
  end
end
