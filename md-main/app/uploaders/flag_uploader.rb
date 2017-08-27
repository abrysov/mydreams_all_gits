class FlagUploader < BaseSecureUploader
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  version :admin do
    process :resize_to_limit => [40, 40]
  end
end
