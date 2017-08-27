module Messageable
  extend ActiveSupport::Concern

  included do
    has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id
    has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id
    has_many :new_messages, -> { not_read }, class_name: 'Message', foreign_key: :receiver_id
  end

  def messages_with(dreamer)
    return Message.none unless dreamer.id

    member_ids = [id, dreamer.id].sort
    Conversation.find_by('member_ids = ARRAY[?]', member_ids).try(:messages) || Message.none
  end

  def send_to(dreamer)
    sent_messages.where receiver: dreamer
  end
end
