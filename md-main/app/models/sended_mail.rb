class SendedMail < ActiveRecord::Base
  include AASM

  belongs_to :email
  belongs_to :dreamer

  aasm column: :state do
    state :enqueued, initial: true
    state :sended
    state :failed

    event :to_send do
      transitions from: :enqueued, to: :sended
    end

    event :to_fail do
      transitions from: :enqueued, to: :failed
    end
  end
end
