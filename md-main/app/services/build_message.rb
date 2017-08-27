class BuildMessage
  def self.call(from:, to:, message_params:)
    ids = [from.id, to.id].sort
    conversation = Conversation.where('member_ids = ARRAY[?]', ids).first_or_create(member_ids: ids)

    message = Message.new(message_params)
    message.sender = from
    # NOTE: receiver CAN be deleted, but his id MUST be present
    message.receiver_id = to.id
    message.conversation = conversation
    message
  end
end
