class DreamerPhotobarSerializer < ActiveModel::Serializer
  include SerializersUrlHelper

  attribute :id
  attribute :full_name
  attribute :age
  attribute :city
  attribute :country
  attribute :photo
  attribute :message

  def full_name
    [object.first_name, object.last_name].join(' ').strip
  end

  def photo
    serialized_url(object.photobar_photo.file.url(:small))
  end

  def message
    object.photobar_added_text
  end

  def city
    object.dream_city.try(:name)
  end

  def country
    object.dream_country.try(:name)
  end
end
