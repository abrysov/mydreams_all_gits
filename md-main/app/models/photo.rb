class Photo < ActiveRecord::Base
  PHOTO_SIZE_MB = 32
  PHOTO_SIZE = PHOTO_SIZE_MB.megabytes
  PHOTO_FORMATS = %w{png jpg jpeg}

  include Commentable
  include Complainable
  include Likeable
  include Moderatable

  belongs_to :dreamer

  mount_uploader :file, PhotoUploader

  validates :file, format: { with: /\.(#{Dreamer::AVATAR_FORMATS.join('|')})\z/i },
                   allow_blank: true
  validate :file_size
  validates :dreamer, :file, presence: true

  scope :not_deleted, -> { where(deleted_at: nil) }

  def url
    file.url
  end

  def thumbUrl
    file.url(:medium)
  end

  def isdefault
    false
  end

  private

  def file_size
    if file.try(:size).try(:to_f) > PHOTO_SIZE
      errors.add(:file, I18n.t('errors.photo.size_limit', max: Photo::PHOTO_SIZE_MB))
    end
  end
end
