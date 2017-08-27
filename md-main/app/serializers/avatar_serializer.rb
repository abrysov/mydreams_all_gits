class AvatarSerializer < ActiveModel::Serializer
  include SerializersUrlHelper

  attribute :id
  attribute :photo
  attribute :crop_meta

  belongs_to :dreamer

  def photo
    versions = [:small, :pre_medium, :medium, :large]
    versions.inject({}) do |acc, version|
      acc[version] = serialized_url(avatar_or_default(object.dreamer, version))
      acc
    end
  end

  class DreamerSerializer < ShortDreamerSerializer; end
end
