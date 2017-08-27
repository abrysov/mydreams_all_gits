class Message < ActiveRecord::Base
  # NOTE: about to be removed
  belongs_to :sender, class_name: 'Dreamer'
  belongs_to :receiver, class_name: 'Dreamer'

  belongs_to :conversation
  has_many :attachments, as: :attachmentable, dependent: :destroy

  scope :read, ->{ where(read: true) }
  scope :not_read, ->{ where(read: false) }
  scope :sent_by, ->(dreamer){ where(sender: dreamer) }
  scope :received_by, ->(dreamer){ where(receiver: dreamer) }

  validates :sender, presence: true
  validates :receiver_id, presence: true # NOTE can be deleted dreamer's id
  validates :message, presence: true
  validate :sender_not_equal_receiver

  private

  def sender_not_equal_receiver
    if self.sender == self.receiver
      errors.add(:sender, 'must be different to receiver')
      errors.add(:receiver, 'must be different to sender')
    end
  end
end
