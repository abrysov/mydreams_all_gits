class Attachment < ActiveRecord::Base
  mount_uploader :file, AttachmentUploader
  mount_base64_uploader :file, AttachmentUploader

  belongs_to :attachmentable, polymorphic: true
end
