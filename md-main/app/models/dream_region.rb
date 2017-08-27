class DreamRegion < ActiveRecord::Base
  belongs_to :dream_country
  has_many :dream_districts
  has_many :dream_cities

  translates :name, :meta, :official_name

  scope :search_by_name, (lambda do |query|
    with_translations(I18n.locale).where('dream_region_translations.name ILIKE ?', "%#{query}%")
  end)
end
