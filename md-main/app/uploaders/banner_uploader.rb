class BannerUploader < BaseSecureUploader
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  version :admin do
    process resize_to_limit: [100, 100]
  end

  version :default do
    process resize_to_limit: [721, 264]
  end
end
