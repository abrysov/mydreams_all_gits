# == Schema Information
#
# Table name: suggested_dreams
#
#  id          :integer          not null, primary key
#  dream_id    :integer
#  receiver_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#  accepted    :boolean          default(FALSE)
#  sender_id   :integer
#

class SuggestedDream < ActiveRecord::Base
  belongs_to :dream
  belongs_to :receiver, class_name: 'Dreamer'
  belongs_to :sender, class_name: 'Dreamer'

  validates :dream, :receiver, presence: true

  scope :accepted, ->{ where(accepted: true) }
  scope :not_accepted, ->{ where(accepted: false) }

  delegate :dreamer, :photo, :title, :description, :likes_count, :comments_count, to: :dream, allow_nil: true

  def accept
    self.update_attribute(:accepted, true) unless self.accepted?
  end

  def reject
    self.update_attribute(:accepted, false) if self.accepted?
  end
end
