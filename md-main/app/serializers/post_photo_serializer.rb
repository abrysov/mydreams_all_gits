class PostPhotoSerializer < ActiveModel::Serializer
  include SerializersUrlHelper

  attribute :id
  attribute :photo
  attribute :post_id

  def photo
    versions = [:small, :medium, :large]
    versions.inject({}) do |acc, version|
      acc[version] = serialized_url(object.photo.url(version))
      acc
    end
  end
end
