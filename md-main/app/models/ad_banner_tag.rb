class AdBannerTag < ActiveRecord::Base
  belongs_to :ad_banner
  belongs_to :tag
end
