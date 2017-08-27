# == Schema Information
#
# Table name: dreamer_cities
#
#  id         :integer          not null, primary key
#  name_ru    :string
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name_en    :string
#  code       :string
#

class DreamerCity < ActiveRecord::Base
  belongs_to :dreamer_country, foreign_key: :country_id
  include GlobalizeName

  validates :dreamer_country, presence: true
  validate :ru_or_en_name

  scope :filter_by_country_id, -> country_id {
    where(country_id: country_id) unless country_id.blank?
  }
  scope :filter_by_name, -> q {
    where("name_#{I18n.locale} ILIKE ?", "#{q}%") unless q.blank?
  }

  def as_json(_options={})
    { id: self.id, name: self.name, country_id: self.country_id }
  end

  def to_s
    name
  end


  def self.filter(f = {})
    f ||= {}
    scoped = where(false)
    scoped = scoped.filter_by_country_id(f[:country_id])     if f[:country_id].present?
    scoped = scoped.filter_by_name(f[:term][:term])          if f[:term][:term].present?
    scoped
  end

  def self.moscow
    #Rails.cache.fetch('dreamer_city_moscow') do
      where(name_ru: 'Москва').first
    #end
  end

  def self.moscow_id
    moscow.try(:id)
  end

  def self.for_select
    all.collect { |i| [i.name, i.id] }
  end

  private

  def ru_or_en_name
    errors.add(:name_ru, 'Хотябы одно название должно присутствовать.') if name_ru.blank? && name_en.blank?
  end
end
