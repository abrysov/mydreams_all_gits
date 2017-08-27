class VipStatus < ActiveRecord::Base
  belongs_to :dreamer
  belongs_to :from_dreamer, class_name: 'Dreamer'

  validates :dreamer, :paid_at, :completed_at, :duration, presence: true
end
