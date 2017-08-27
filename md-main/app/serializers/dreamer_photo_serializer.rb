class DreamerPhotoSerializer < ActiveModel::Serializer
  include SerializersUrlHelper

  # TODO: likes_count, comments_count, ios_safe, nsfw?
  attribute :id
  attribute :photo
  attribute :preview
  attribute :caption

  def photo
    serialized_url(object.file.url(:large))
  end

  def preview
    serialized_url(object.file.url(:small))
  end
end
