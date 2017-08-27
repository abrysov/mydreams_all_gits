class PostPhoto < ActiveRecord::Base
  belongs_to :post
  belongs_to :dreamer

  mount_uploader :photo,            PostPhotoUploader
  mount_base64_uploader :photo,     PostPhotoUploader

  validates :photo, presence: true
end
