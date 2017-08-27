class DreamerDecorator < ApplicationDecorator
  delegate_all

  include Draper::LazyHelpers

  def full_name
    [object.first_name, object.last_name].reject(&:blank?).join(' ')
  end
  alias_method :to_s, :full_name

  def truncate_full_name
    full_name[0...15]
  end

  def first_name_and_age
    [object.first_name, object.age].compact.join(', ')
  end

  def last_name_and_age
    [object.last_name, object.age].compact.join(', ')
  end

  def full_name_and_age
    [full_name, object.age].compact.join(', ')
  end

  def age_and_location
    [object.age, object.dream_country, object.dream_city].compact.join(', ')
  end

  def flybook_photos
    @flybook_photos ||= object.photos.not_deleted.order(id: :desc)
  end

  def flybook_dreams
    @flybook_dreams ||= Dreams::DreamsFinder.new(object.dreams).filter(params, current_dreamer)
  end

  def flybook_suggested_dreams
    @flybook_suggested_dreams ||= object.suggested_dreams.not_accepted.joins(:dream).merge(Dream.all).preload(dream: {dreamer: :dream_city})
  end

  def flybook_suggested_posts
    @flybook_suggested_posts ||= object.suggested_posts.not_accepted.joins(:post).merge(Post.all).preload(post: {dreamer: :dream_city})
  end

  def flybook_came_true_dreams
    flybook_dreams.select { |d| d[:came_true] }
  end

  def flybook_not_came_true_dreams
    flybook_dreams.select { |d| !d[:came_true] }
  end

  def flybook_received_friends
    @flybook_received_friends ||= object.friend_applicants
  end

  def flybook_nb_gifted_certificates
    @flybook_nb_gifted_certificates ||= Certificate.paid
                                        .where(certifiable_type: 'Dream')
                                        .where(certifiable_id: object.dreams.pluck(:id))
                                        .where.not(gifted_by_id: nil)
                                        .where(accepted: false)
                                        .count
  end

  def flybook_certificates_sum
    @flybook_certificates_sum ||= flybook_dreams.sum(:launches_count)
  end

  def flybook_nb_received_friends
    @flybook_nb_received_friends ||= object.friend_applicants.count
  end

  def flybook_nb_suggested_dreams
    @flybook_nb_suggested_dreams ||= object.suggested_dreams.not_accepted.joins(:dream).merge(Dream.all).count
  end

  def flybook_nb_suggested_posts
    @flybook_nb_suggested_posts ||= object.suggested_posts.not_accepted.joins(:post).merge(Post.all).count
  end

  def flybook_nb_new_followers
    @flybook_nb_new_followers ||= object.new_followers.count
  end

  def flybook_nb_new_friends_dreams
    @flybook_nb_new_friends_dreams ||= object.nb_unviewed_friends_dreams
  end

  def flybook_nb_new_friends_activities
    @flybook_nb_new_friends_activities ||= object.friends_feed.not_viewed.count
  end

  def flybook_nb_new_received_messages
    @flybook_nb_new_received_messages ||= object.received_messages.not_read.count
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
end
