class AdLink < ActiveRecord::Base
  has_many :ad_link_tags, dependent: :destroy
  has_many :tags, through: :ad_link_tags
  validates :url, format: { with: %r{https?://(www.)?\w*\.\w*},
                            message: 'Invalid domain format' }
end
