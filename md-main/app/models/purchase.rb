class Purchase < ActiveRecord::Base
  extend Enumerize
  include AASM

  belongs_to :dreamer
  belongs_to :destination_dreamer, class_name: 'Dreamer'

  belongs_to :destination, polymorphic: true
  belongs_to :product

  has_many :purchase_transactions

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :dreamer, :product, presence: true

  scope :completed, -> { where(state: :complete) }
  scope :failed, -> { where(state: :failed) }
  scope :in_processing, -> { where(state: :processing) }

  aasm column: :state do
    state :pending, initial: true
    state :processing
    state :complete
    state :failed

    event :to_processing do
      transitions from: :pending, to: :processing
    end

    event :to_complete do
      transitions from: :processing, to: :complete
    end

    event :to_fail do
      transitions from: :processing, to: :failed
    end
  end
end
