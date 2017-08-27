class PurchaseTransaction < ActiveRecord::Base
  extend Enumerize
  include AASM

  belongs_to :account
  belongs_to :purchase
  has_one :reason_transaction, as: :reason, class_name: 'Transaction'

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :operation, presence: true
  validates :account, presence: true

  enumerize :operation, in: [:refill, :buy], default: :buy

  scope :completed, -> { where(state: :complete) }
  scope :failed, -> { where(state: :failed) }

  # TODO: more state?
  aasm column: :state do
    state :pending, initial: true
    state :complete
    state :failed

    event :to_complete do
      transitions from: :pending, to: :complete
    end

    event :to_fail do
      transitions from: :pending, to: :failed
    end
  end
end
