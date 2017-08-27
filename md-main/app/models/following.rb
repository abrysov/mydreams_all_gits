class Following < ActiveRecord::Base
  include AASM

  belongs_to :follower, class_name: Dreamer, counter_cache: :followees_count
  belongs_to :followee, class_name: Dreamer, counter_cache: :followers_count

  aasm column: 'view_state' do
    state :unviewed, initial: true
    state :viewed

    event :view do
      transitions to: :viewed
    end
  end

  validates :follower, presence: true, uniqueness: { scope: :followee_id }
  validates :followee, presence: true
end
