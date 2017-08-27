class TopDreamSerializer < ActiveModel::Serializer
  include SerializersUrlHelper

  attribute :id
  attribute :title
  attribute :description
  attribute :photo
  attribute :likes_count
  attribute :comments_count
  attribute :liked_by_me

  def photo
    versions = [:small, :medium, :large]
    versions.inject({}) do |acc, version|
      acc[version] = serialized_url(object.photo.url(version))
      acc
    end
  end

  def liked_by_me
    !!scope && scope.likes.where(likeable: object).exists?
  end
end
