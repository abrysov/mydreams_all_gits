class ConversationSerializer < ActiveModel::Serializer
  attribute :id
  attribute :updated_at
  attribute :dreamers_count
  attribute :unreaded_messages_count

  has_many :messages, key: :last_message, serializer: ConversationMessageSerializer do
    object.messages.last
  end

  has_many :members, key: :dreamers do
    object.members.where.not(id: scope.id)
  end

  def dreamers_count
    object.member_ids.count
  end

  def unreaded_messages_count
    object.messages.where.not('viewed_ids @> ARRAY[?]', scope.id).count
  end

  class DreamerSerializer < ShortDreamerSerializer; end
end
