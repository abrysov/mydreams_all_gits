module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable

    has_many :last_likes, -> { joins(:dreamer).order(id: :desc).limit(5) }, class_name: 'Like', as: :likeable
  end

  def liked_dreamers
    at = Like.arel_table
    Dreamer.joins(:likes)
           .where(at[:likeable_type].eq(self.class))
           .where(at[:likeable_id].eq(self.id))
           .order(at[:id].desc)
  end

  def liked_by?(dreamer)
    Like.exists?(dreamer: dreamer, likeable: self)
  end
end
