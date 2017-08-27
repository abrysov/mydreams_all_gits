class VideoUploader < BaseSecureUploader
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
end
