class ExternalTransaction < ActiveRecord::Base
  extend Enumerize
  include AASM

  belongs_to :account
  belongs_to :invoice
  has_one :reason_transaction, as: :reason, class_name: 'Transaction'

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :operation, :account, :gateway_id, presence: true

  # TODO: rollback?
  enumerize :operation, in: [:refill, :rollback], default: :refill

  scope :success, -> { where(state: :success) }
  scope :pending, -> { where state: :pending }

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
