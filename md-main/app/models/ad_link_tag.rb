class AdLinkTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :ad_link
end
