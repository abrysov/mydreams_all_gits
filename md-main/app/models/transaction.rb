class Transaction < ActiveRecord::Base
  extend Enumerize
  include AASM

  belongs_to :account
  belongs_to :reason, polymorphic: true

  before_create :amount_before_action

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :operation, presence: true
  validates :account, presence: true

  scope :completed, -> { where(state: :complete) }
  scope :failed, -> { where(state: :failed) }

  enumerize :operation, in: [:refill, :buy], default: :buy

  aasm column: :state do
    state :pending, initial: true
    state :complete
    state :failed

    event :to_complete do
      transitions from: :pending, to: :complete, before: :amount_before_action
    end

    event :to_fail do
      transitions from: :pending, to: :failed, before: :amount_before_action
    end
  end

  def amount_before_action
    self.before = account.amount
    case operation
    when 'buy'
      self.after = account.amount - amount
    when 'refill'
      self.after = account.amount + amount
    end
  end
end
