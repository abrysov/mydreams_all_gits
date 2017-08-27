class MigrateMessages
  def self.call
    Message.find_each do |message|
      ids = [message.receiver_id, message.sender_id].sort
      if Conversation.where('member_ids = ARRAY[?]', ids).exists?
        conversation = Conversation.find_by('member_ids = ARRAY[?]', ids)
      else
        conversation = Conversation.create(member_ids: ids)
      end
      message.update_attributes(conversation: conversation)
    end
  end
end
