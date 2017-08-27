class Friendship < ActiveRecord::Base
  validates :member_ids, length: { is: 2, message: :must_be_two }

  def members
    Dreamer.where(id: member_ids)
  end

  def friend_for(dreamer)
    friend_id = (member_ids - [dreamer.id]).first
    Dreamer.find friend_id
  end

  # NOTE: temporarily enabled due to migration to new friendship schema
  # NOTE: remove later
  belongs_to :dreamer
  belongs_to :friend, class_name: 'Dreamer'

  scope :by_friend, ->(friend) { where(friend_id: friend.id) }
  scope :by_dreamer, ->(dreamer) { where(dreamer_id: dreamer.id) }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :not_accepted, -> { where(accepted_at: nil) }

  scope :subscribings, -> { where(subscribing: true) }
  scope :not_subscribings, -> { where(subscribing: [false, nil]) }

  scope :processed, -> { where(processed: true) }
  scope :not_processed, -> { where(processed: [false, nil]) }
end
