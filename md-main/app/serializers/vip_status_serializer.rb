class VipStatusSerializer < ActiveModel::Serializer
  attribute :id
  attribute :paid_at
  attribute :completed_at
  attribute :duration
  attribute :comment

  belongs_to :dreamer
  belongs_to :from_dreamer, class_name: 'Dreamer'

  class DreamerSerializer < ShortDreamerSerializer; end
end
