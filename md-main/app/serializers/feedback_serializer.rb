class FeedbackSerializer < ActiveModel::Serializer
  include SerializersUrlHelper

  attributes :id
  attributes :action
  attributes :created_at

  belongs_to :dreamer
  belongs_to :initiator
  belongs_to :resource, polymorphic: true

  class DreamerSerializer < ShortDreamerSerializer; end
end
