class DreamCountry < ActiveRecord::Base
  has_many :dream_regions
  has_many :dream_districts
  has_many :dream_cities
  has_many :dreamers

  translates :name, :meta, :alt_name

  scope :search_by_name, (lambda do |query|
    with_translations(I18n.locale).where('dream_country_translations.name ILIKE ?', "%#{query}%")
  end)

  def self.russia
    Rails.cache.fetch('dream_country_russia') do
      search_by_name(name: 'Россия').first
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
end
