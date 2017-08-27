class PhotoUploader < BaseSecureUploader
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  version :admin do
    process resize_to_limit: [100, 100]
  end

  version :large do
    process resize_to_limit: [800, 800]
  end

  version :medium do
    process resize_to_limit: [400, 400]
  end

  version :small do
    process resize_and_crop: 100
    # process resize_to_limit: [100, 100]
  end

  def resize_and_crop(size)
    manipulate! do |image|
      if image[:width] < image[:height]
        remove = ((image[:height] - image[:width]) / 2).round
        image.shave("0x#{remove}")
      elsif image[:width] > image[:height]
        remove = ((image[:width] - image[:height]) / 2).round
        image.shave("#{remove}x0")
      end
      image.resize("#{size}x#{size}")
      image
    end
  end

  def extension_white_list
    Dreamer::AVATAR_FORMATS
  end
end
