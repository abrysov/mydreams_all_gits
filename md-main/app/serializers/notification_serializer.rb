class NotificationSerializer < ActiveModel::Serializer
  attribute :id
  attribute :action
  attribute :created_at

  belongs_to :dreamer
  belongs_to :initiator
  belongs_to :resource, polymorphic: true

  class DreamerSerializer < ShortDreamerSerializer; end
end
