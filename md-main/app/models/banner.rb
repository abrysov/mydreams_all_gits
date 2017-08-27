class Banner < ActiveRecord::Base
  belongs_to :advertiser
  has_many :ad_page_banners
  has_many :ad_pages, through: :ad_page_banners
  mount_uploader :image, BannerUploader
  mount_base64_uploader :image, BannerUploader

  validates :link, format: { with: %r{https?://(www.)?\w*\.\w*},
                             message: 'Invalid domain format' }
  scope :relevant, -> { order(:show_count) }
  scope :active, -> { where('date_start <= ? AND date_end >= ?', DateTime.now, DateTime.now) }

  before_save :update_md5_hash

  def update_md5_hash
    self.link_hash = Digest::MD5.new.update(link) if link.present?
  end
end
