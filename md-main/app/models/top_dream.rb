class TopDream < ActiveRecord::Base
  include Complainable
  include Likeable
  include Logable
  include Moderatable
  include Commentable
  extend Enumerize

  enumerize :locale, in: I18n.available_locales, default: :ru

  has_many :attachments, as: :attachmentable, dependent: :destroy

  scope :by_locale, -> { where(locale: I18n.locale) }
  scope :by_position, -> { order(:position) }
  scope :most_liked, -> { order(likes_count: :desc) }
  scope :most_commented, -> { order(comments_count: :desc) }
  scope :newest_first, -> { order(created_at: :desc) }

  validates :title, presence: true
  validates :description, presence: true

  mount_uploader :photo, DreamPhotoUploader
  mount_base64_uploader :photo, DreamPhotoUploader

  before_create :set_position

  def top_dream?
    true
  end

  def cropping?
    false
  end

  private

  def set_position
    self.position = (TopDream.by_position.last.try(:position) || 0) + 1
  end
end
