class DreamSerializer < ActiveModel::Serializer
  include SerializersUrlHelper

  attribute :id
  attribute :title
  attribute :description
  attribute :photo
  attribute :url
  attribute :certificate_type
  attribute :liked_by_me
  attribute :likes_count
  attribute :comments_count
  attribute :launches_count
  attribute :created_at

  attribute :restriction_level do
    case object.restriction_level.to_i
    when 2 then 'private'
    when 1 then 'friends'
    when 0 then 'public'
    end
  end

  attribute :fulfilled do
    object.came_true.present?
  end

  belongs_to :dreamer, serializer: ShortDreamerSerializer

  def certificate_type
    dream_type = object.summary_certificate_type_name || 'my_dreams'
    dream_type.titleize
  end

  def liked_by_me
    !!scope && scope.likes.where(likeable: object).exists?
  end

  def photo
    versions = [:small, :medium, :large]
    versions.inject({}) do |acc, version|
      acc[version] = serialized_url(object.photo.url(version))
      acc
    end
  end

  def url
    Rails.application.routes.url_helpers.d_dream_path(I18n.locale, object.dreamer_id, object.id)
  end
end
