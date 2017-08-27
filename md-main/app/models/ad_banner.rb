class AdBanner < ActiveRecord::Base
  has_many :ad_banner_tags, dependent: :destroy
  has_many :tags, through: :ad_banner_tags
  mount_uploader :image, BannerUploader
  mount_base64_uploader :image, BannerUploader

  validates :url, format: { with: %r{https?://(www.)?\w*\.\w*},
                            message: 'Invalid domain format' }
end
