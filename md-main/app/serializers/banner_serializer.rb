class BannerSerializer < ActiveModel::Serializer
  include SerializersUrlHelper

  attribute :link_hash
  attribute :image

  def image
    versions = [:default]
    versions.inject({}) do |acc, version|
      acc[version] = serialized_url(object.image.url(version))
      acc
    end
  end
end
