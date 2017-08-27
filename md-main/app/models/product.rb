class Product < ActiveRecord::Base
  extend Enumerize
  include AASM

  has_many :purchases
  has_many :properties, class_name: ProductProperty, dependent: :destroy

  validates :product_type, presence: true
  validates :cost, presence: true, numericality: { greater_than: 0 }

  enumerize :product_type, in: [:cert, :vip, :special], default: :vip

  scope :certificates, -> { where(product_type: 'cert') }
  scope :vip_statuses, -> { where(product_type: 'vip') }
  scope :special, -> { where(product_type: 'special') }
  scope :without_special, -> { where.not(product_type: 'special') }

  aasm column: :state do
    state :active, initial: true
    state :locked

    event :lock do
      transitions from: :active, to: :locked
    end

    event :activate do
      transitions from: :locked, to: :active
    end
  end

  def special?
    product_type == 'special'
  end

  def vip?
    product_type == 'vip'
  end

  def certificate?
    product_type == 'cert'
  end

  def certificate_name
    properties.find_by(key: 'certificate_name').try(:value)
  end
end
