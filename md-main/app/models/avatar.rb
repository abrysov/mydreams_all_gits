class Avatar < ActiveRecord::Base
  AVATAR_SIZE_MB = 5
  AVATAR_SIZE = AVATAR_SIZE_MB.megabytes

  belongs_to :dreamer

  mount_uploader :photo, OriginalAvatarUploader
  mount_base64_uploader :photo, OriginalAvatarUploader

  validate :file_size
  validates :dreamer, :photo, :crop_meta, presence: true

  serialize :crop_meta

  private

  def file_size
    if photo.try(:size).try(:to_f).to_i > Avatar::AVATAR_SIZE
      errors.add(:photo, I18n.t('errors.dreamer.avatar.size_limit', max: Avatar::AVATAR_SIZE_MB))
    end
  end
end
