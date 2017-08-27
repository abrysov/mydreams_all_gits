class Ability
  include CanCan::Ability

  def initialize(dreamer)
    dreamer ||= Dreamer.new
    for_other_dreamers(dreamer)
    for_dreams(dreamer)
    for_comments(dreamer)
    for_photos(dreamer)
    for_posts(dreamer)
  end

  def for_posts(dreamer)
    can :manage, Post do |post|
      post.dreamer == dreamer
    end
  end

  def for_comments(dreamer)
    can :manage, Comment do |comment|
      comment.dreamer == dreamer
    end
  end

  def for_photos(dreamer)
    can :manage, Photo do |photo|
      photo.dreamer == dreamer
    end
  end

  # WARN: убран taken_from, тк не позволял редактировать мечту, если она была взята у кого-то
  def for_dreams(dreamer)
    can :edit, Dream do |dream|
      dreamer == dream.dreamer #&& dream.taken_from.blank?
    end
    can :take, Dream do |dream|
      dream.dreamer != dreamer
    end
  end

  def for_other_dreamers(dreamer)
    can :manage_account, Dreamer
    can :manage_photos, Dreamer do |person|
      person == dreamer
    end
  end
end
