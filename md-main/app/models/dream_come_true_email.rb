class DreamComeTrueEmail < ActiveRecord::Base
  include AASM

  belongs_to :dream
  belongs_to :sender, class_name: Dreamer

  scope :sended, -> { where(state: :sended) }

  mount_uploader :snapshot, SnapshotUploader

  validates :dream, :sender, presence: true

  aasm column: :state do
    state :pending, initial: true
    state :tested
    state :sended
    state :failed

    event :to_send do
      transitions from: [:pending, :tested], to: :sended
    end

    event :to_test do
      transitions from: [:pending, :tested], to: :tested
    end

    event :to_fail do
      transitions from: [:pending, :tested], to: :failed
    end
  end
end
