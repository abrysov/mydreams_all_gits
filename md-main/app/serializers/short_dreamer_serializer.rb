class ShortDreamerSerializer < ActiveModel::Serializer
  include SerializersUrlHelper

  attribute :id
  attribute :full_name
  attribute :gender
  attribute :birthday
  attribute :age
  attribute :avatar
  attribute :url
  attribute :vip
  attribute :celebrity
  attribute :is_online

  has_one :dream_country, key: :country
  has_one :dream_city, key: :city

  def full_name
    "#{object.first_name} #{object.last_name}".strip
  end

  def vip
    object.is_vip?
  end

  def is_online
    object.online?
  end

  def celebrity
    object.celebrity.present?
  end

  def avatar
    {}.tap do |hash|
      [:small, :pre_medium, :medium, :large].each do |version|
        url = avatar_or_default(object, version)
        hash[version] = serialized_url(url)
      end
    end
  end

  def url
    Rails.application.routes.url_helpers.d_path(I18n.locale, object.id)
  end
end
