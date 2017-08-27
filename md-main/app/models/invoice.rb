# TODO: use gem enumerable instead of integer constants
class Invoice < ActiveRecord::Base
  VIP_SELF_TYPE = 1
  VIP_GIFT_TYPE = 2
  CERTIFICATE_TYPE = 4

  belongs_to :dreamer
  belongs_to :payable, polymorphic: true

  validates :dreamer, :state, :amount, presence: true

  scope :success, -> { where(state: :success) }
  scope :pending, -> { where state: :pending }
  scope :vip_gift_type, -> { where(payment_type: VIP_GIFT_TYPE) }

  state_machine :state, initial: :pending do
    state :pending
    state :success
    state :fail

    event :success do
      transition pending: :success
    end
    event :fail do
      transition pending: :fail
    end
  end

  # TODO: rename 'amount' field to 'total'
  def total
    amount
  end

  # TODO: rename 'amount' field to 'total'
  def total=(value)
    self[:amount] = value
  end

  def certificate?
    [Invoice::CERTIFICATE_TYPE].include? payment_type
  end

  def vip?
    [Invoice::VIP_SELF_TYPE, Invoice::VIP_GIFT_TYPE].include? payment_type
  end

  def vip_gift?
    payment_type == VIP_GIFT_TYPE
  end

  def dream_gift?
    payment_type == Invoice::DREAM_GIFT_TYPE
  end
end
