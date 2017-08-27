class ConversationMessageSerializer < ActiveModel::Serializer
  attribute :id
  attribute :message, key: :body
  attribute :created_at

  belongs_to :sender, key: :dreamer

  class DreamerSerializer < ShortDreamerSerializer; end
end
