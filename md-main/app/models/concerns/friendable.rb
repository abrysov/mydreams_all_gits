module Friendable
  extend ActiveSupport::Concern

  included do
    # FIXME: remove after data migration
    has_many :old_friendships, class_name: Friendship
    has_many :old_friends, through: :old_friendships, source: :friend
    has_many :not_accepted_inverse_friendships, ->{ not_accepted }, class_name: 'Friendship', foreign_key: :friend_id
  end

  def suggested_friends_dreams
    if (ids = friends.pluck(:id)).empty?
      SuggestedDream.none
    else
      SuggestedDream.where(receiver_id: ids)
    end
  end

  def friends_feed
    Activity.where("owner_id IN (#{Dreamer.find(id).subscriptions.select(:subscriber_id).to_sql})")
      .includes(:trackable, owner: [:dream_city])
  end

  # FIXME: remove after data migration
  def all_accepted_friends_ids
    if @all_accepted_friends_ids.nil?
      assoc = self.class.reflect_on_association(:old_friends)
      klass = assoc.through_reflection.klass
      f_at  = klass.arel_table

      q = klass.where(
        f_at[assoc.foreign_key].eq(self[assoc.association_primary_key])
        .or(f_at[assoc.association_foreign_key].eq(self[assoc.association_primary_key]))
      )
      .accepted
      .order(f_at[:updated_at].asc)

      @all_accepted_friends_ids = q.map { |f| f.friend_id == self.id ? f.dreamer_id : f.friend_id }
    end

    @all_accepted_friends_ids
  end
end
