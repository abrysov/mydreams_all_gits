class DreamerSerializer < ShortDreamerSerializer
  attribute :first_name
  attribute :last_name
  attribute :birthday
  attribute :status
  attribute :dreambook_bg
  attribute :friends_count
  attribute :followers_count
  attribute :dreams_count
  attribute :fulfilled_dreams_count
  attribute :launches_count
  attribute :photos_count
  attribute :visits_count
  attribute :views_count
  attribute :is_blocked
  attribute :is_deleted
  attribute :i_friend
  attribute :i_follower

  def dreambook_bg
    versions = [:cropped]
    versions.inject({}) do |acc, version|
      acc[version] = serialized_url(object.dreambook_bg.url(version))
      acc
    end
  end

  def photos_count
    object.photos.count
  end

  def friends_count
    object.friends.count
  end

  def followers_count
    object.followers.count
  end

  def dreams_count
    object.dreams.count
  end

  def fulfilled_dreams_count
    object.dreams.where(came_true: true).count
  end

  def launches_count
    object.dreams.sum(:launches_count)
  end

  def views_count
    object.passive_visits.count
  end

  def is_deleted
    object.deleted_at.present?
  end

  def is_blocked
    object.blocked_at.present?
  end

  def i_friend
    !!scope && object.friends_with?(scope)
  end

  def i_follower
    !!scope && object.has_follower?(scope)
  end
end
