class DreamPhotoUploader < BaseSecureUploader
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  version :admin do
    process :crop
    process resize_to_limit: [100, 100]
  end

  version :small do
    process :crop
    process resize_to_limit: [100, 100]
  end

  version :medium do
    process :crop
    process resize_to_limit: [190, 190]
  end

  version :large do
    process :crop
    process resize_to_limit: [540, 540]
  end

  def extension_white_list
    Dreamer::AVATAR_FORMATS
  end

  private

  def crop
    return unless model.cropping?

    manipulate! do |img|
      x = model.crop_meta[:x].to_i
      y = model.crop_meta[:y].to_i
      w = model.crop_meta[:width].to_i
      h = model.crop_meta[:height].to_i

      img.crop "#{w}x#{h}+#{x}+#{y}"
      img
    end
  end
end
