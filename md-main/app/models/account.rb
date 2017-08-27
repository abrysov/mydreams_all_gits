class Account < ActiveRecord::Base
  belongs_to :dreamer
  has_many :transactions

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :dreamer, presence: true
end
