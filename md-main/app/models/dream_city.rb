class DreamCity < ActiveRecord::Base
  belongs_to :dream_country
  belongs_to :dream_region
  belongs_to :dream_district

  translates :name, :meta, :prefix

  scope :search_by_name, (lambda do |query|
    with_translations(I18n.locale).where('dream_city_translations.name ILIKE ?', "%#{query}%")
  end)

  scope :filter_by_country_id, -> country_id {
    where(dream_country_id: country_id) unless country_id.blank?
  }
  scope :filter_by_name, -> q {
    search_by_name(q) unless q.blank?
  }

  def city_meta
    meta
  end

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
    with_translations(:ru).where('dream_city_translations.name = ?', "Москва").first
  end

  def self.moscow_id
    moscow.try(:id)
  end

  def self.for_select
    all.collect { |i| [i.name, i.id] }
  end
end
