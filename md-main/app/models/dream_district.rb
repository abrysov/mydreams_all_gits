class DreamDistrict < ActiveRecord::Base
  belongs_to :dream_country
  belongs_to :dream_region
  has_many :dream_cities

  translates :name, :meta
end
