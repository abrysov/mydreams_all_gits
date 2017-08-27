class PurchaseSerializer < ActiveModel::Serializer
  attribute :id
  attribute :comment
  attribute :amount
  attribute :state
  attribute :destination

  belongs_to :dreamer
  # TODO: destination:dream:dreamer or destination:dreamer or destination_dreamer?
  #  has_one :destination_dreamer, class_name: Dreamer, serializer: ShortDreamerSerializer
  belongs_to :product
  belongs_to :destination

  class DreamerSerializer < ShortDreamerSerializer; end
end
