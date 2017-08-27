# == Schema Information
#
# Table name: suggested_posts
#
#  id          :integer          not null, primary key
#  post_id     :integer
#  receiver_id :integer          not null
#  accepted    :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#  sender_id   :integer
#

class SuggestedPost < ActiveRecord::Base
  belongs_to :post
  belongs_to :receiver, class_name: 'Dreamer'
  belongs_to :sender, class_name: 'Dreamer'

  validates :post, :receiver, presence: true

  scope :accepted, ->{ where(accepted: true) }
  scope :not_accepted, ->{ where(accepted: false) }

  delegate :dreamer, :photo, :title, :description, :likes_count, :comments_count, to: :post, allow_nil: true

  def accept
    self.update_attribute(:accepted, true) unless self.accepted?
  end

  def reject
    self.update_attribute(:accepted, false) if self.accepted?
  end
end
