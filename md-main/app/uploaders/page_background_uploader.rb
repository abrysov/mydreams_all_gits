class PageBackgroundUploader < BaseSecureUploader
  include CarrierWave::MiniMagick

  def extension_white_list
    %w{png jpg jpeg}
  end

  version :large do
    process resize_to_limit: [1280, 1024]
  end
end
