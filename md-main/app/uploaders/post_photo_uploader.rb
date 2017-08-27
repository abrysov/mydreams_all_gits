class PostPhotoUploader < BaseSecureUploader
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  version :admin do
    process :resize_to_limit => [260, 175]
  end

  version :small do
    process :resize_to_limit => [100, 67]
  end

  version :medium do
    process :resize_to_limit => [260, 175]
  end

  version :large do
    process :resize_to_limit => [800, 540]
  end

  def extension_white_list
    Dreamer::AVATAR_FORMATS
  end
end
