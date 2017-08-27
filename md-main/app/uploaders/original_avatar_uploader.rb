class OriginalAvatarUploader < BaseSecureUploader
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  process resize_to_fit: [1920, 1080]

  def content_type_whitelist
    %r{/image\//}
  end

  def extension_whitelist
    Dreamer::AVATAR_FORMATS
  end
end
