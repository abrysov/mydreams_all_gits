class CertificateSerializer < ActiveModel::Serializer
  attribute :id
  attribute :accepted
  attribute :wish
  attribute :launches
  attribute :certificate_type
  attribute :certificate_type_name
  attribute :certifiable
  attribute :gifted_by
  attribute :created_at

  has_one :certifiable
  has_one :gifted_by

  def certificate_type
    object.certificate_type.name
  end

  def certificate_type_name
    object.certificate_type.name.titleize
  end

  class DreamerSerializer < ShortDreamerSerializer; end
end
