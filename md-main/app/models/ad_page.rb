class AdPage < ActiveRecord::Base
  has_many :ad_page_banners
  has_many :banners, through: :ad_page_banners
  has_many :active_banners, -> { active }, through: :ad_page_banners, source: :banner
end
