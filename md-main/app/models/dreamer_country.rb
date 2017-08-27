# == Schema Information
#
# Table name: dreamer_countries
#
#  id         :integer          not null, primary key
#  name_ru    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name_en    :string
#  flag       :string
#  code       :string
#

class DreamerCountry < ActiveRecord::Base
  has_many :dreamer_cities, class_name: 'DreamerCity', foreign_key: :country_id

  include GlobalizeName
  validate :ru_or_en_name
  mount_uploader :flag, FlagUploader

  def self.russia
    Rails.cache.fetch('dreamer_country_russia') do
      where(name_ru: 'Россия').first
    end
  end

  def as_json(options = {})
    {id: id, name: name}
  end

  def to_s
    name
  end

  def self.for_select
    all.collect { |i| [i.name, i.id] }
  end

  private

  def ru_or_en_name
    errors.add(:name_ru, 'Хотябы одно название должно присутствовать.') if name_ru.blank? && name_en.blank?
  end
end
