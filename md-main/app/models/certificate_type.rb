# TODO: rename 'value' field to 'coefficient'
class CertificateType < ActiveRecord::Base
  scope :by_value, -> { order(value: :desc) }

  validates :name, :value, presence: true
end
