class AvatarUploader < BaseSecureUploader
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  version :admin do
    process :crop
    process resize_to_limit: [100, 100]
  end

  version :small do
    process :crop
    process resize_to_limit: [40, 40]
  end

  version :pre_medium do
    process :crop
    process resize_to_limit: [120, 120]
  end

  version :medium do
    process :crop
    process resize_to_limit: [400, 400]
  end

  version :large do
    process :crop
    process resize_to_limit: [500, 500]
  end

  def extension_white_list
    Dreamer::AVATAR_FORMATS
  end

  private

  def crop
    # return unless model.avatar_crop_x.present?
    manipulate! do |img|
      x = model.avatar_crop_x.to_i
      y = model.avatar_crop_y.to_i
      w = model.avatar_crop_w.to_i
      h = model.avatar_crop_h.to_i
      x, y, w, h = size_from_remote_url(img) if [x, y, w, h].uniq == [0]
      img.crop "#{w}x#{h}+#{x}+#{y}"
      img
    end
  end

  def size_from_remote_url(img)
    width, height = `identify -format "%wx%h" #{img.path}`.split('x')
    min = [width, height].map(&:to_i).min
    [0, 0, min, min]
  end
end
