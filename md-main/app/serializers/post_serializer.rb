class PostSerializer < ActiveModel::Serializer
  include SerializersUrlHelper

  attribute :id
  attribute :photos
  attribute :content
  attribute :likes_count
  attribute :comments_count
  attribute :restriction_level
  attribute :liked_by_me
  attribute :created_at

  belongs_to :dreamer

  has_many :last_likes
  has_many :last_comments
  has_many :photos, serializer: PostPhotoSerializer

  def restriction_level
    case object.restriction_level.to_i
    when 2 then 'private'
    when 1 then 'friends'
    when 0 then 'public'
    end
  end

  def liked_by_me
    !!scope && scope.likes.where(likeable: object).exists?
  end

  class DreamerSerializer < ShortDreamerSerializer; end
end
