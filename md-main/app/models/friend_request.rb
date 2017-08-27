class FriendRequest < ActiveRecord::Base
  belongs_to :sender, class_name: Dreamer
  belongs_to :receiver, class_name: Dreamer

  validates :sender, presence: true, uniqueness: { scope: :receiver }
  validates :receiver, presence: true
  validate :check_member_ids

  scope :sender_online, -> { joins(:sender).merge(Dreamer.online) }
  scope :receiver_online, -> { joins(:receiver).merge(Dreamer.online) }

  scope :sender_vip, -> (value) { joins(:sender).merge(Dreamer.by_vip(value)) }
  scope :receiver_vip, -> (value) { joins(:receiver).merge(Dreamer.by_vip(value)) }

  scope :sender_filter_by_gender, (lambda do |value|
    joins(:sender).merge(Dreamer.filter_by_gender(value))
  end)
  scope :receiver_filter_by_gender, (lambda do |value|
    joins(:receiver).merge(Dreamer.filter_by_gender(value))
  end)

  scope :sender_by_age, -> (from, to) { joins(:sender).merge(Dreamer.by_age(from, to)) }
  scope :receiver_by_age, -> (from, to) { joins(:receiver).merge(Dreamer.by_age(from, to)) }

  scope :sender_filter_by_city_id, (lambda do |value|
    joins(:sender).merge(Dreamer.filter_by_city_id(value))
  end)
  scope :receiver_filter_by_city_id, (lambda do |value|
    joins(:receiver).merge(Dreamer.filter_by_city_id(value))
  end)

  scope :sender_filter_by_country_id, (lambda do |value|
    joins(:sender).merge(Dreamer.filter_by_country_id(value))
  end)
  scope :receiver_filter_by_country_id, (lambda do |value|
    joins(:receiver).merge(Dreamer.filter_by_country_id(value))
  end)

  private

  def check_member_ids
    errors.add(:base, I18n.t('relations.errors.invalid_dreamer')) if sender_id == receiver_id
  end
end
