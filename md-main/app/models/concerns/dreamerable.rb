module Dreamerable
  extend ActiveSupport::Concern

  include ApplicationHelper
  include Complainable
  include Friendable
  include Logable
  include Messageable
  include Moderatable
  include Visitable
  include PgSearch
  extend Enumerize

  def active?
    deleted_at.nil? && blocked_at.nil? && confirmed?
  end

  def password_function
    Devise.friendly_token.first(15)
  end

  def liked?(entity)
    likes.where(likeable_type: entity.class, likeable_id: entity.id).exists?
    # var = "@likes_#{entity.class.name.downcase}"
    # unless instance_variable_defined?(var)
    #   instance_variable_set(var, likes.where(likeable_type: entity.class).pluck(:likeable_id))
    # end

    # instance_variable_get(var).include?(entity.id)
  end

  def pretty_birthday
    birthday.is_a?(Date) ? birthday.strftime('%d-%m-%Y') : birthday
  end

  def avatar_url
    avatar.url
  end

  def avatar_url_or_default_small
    avatar_or_default(self, :small)
  end

  def avatar_url_or_default_medium
    avatar_or_default(self, :medium)
  end

  def city_and_country
    "#{dream_city.try(:name)}, #{dream_country.try(:name)}"
  end

  def unviewed_news
    Dreamer.project_dreamer.posts.
      where('posts.created_at > ?', last_news_viewed_at).
      order(created_at: :desc)
  end

  def update_last_viewed_news_time(datetime = Time.zone.now)
    update_column(:last_news_viewed_at, datetime)
  end
end
