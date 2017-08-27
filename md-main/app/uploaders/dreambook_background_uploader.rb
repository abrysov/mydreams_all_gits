class DreambookBackgroundUploader < BaseSecureUploader
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  version :cropped do
    process :crop
    process resize_to_limit: [936, 198]
  end

  def extension_white_list
    %w{png jpg jpeg}
  end

  private

  def crop
    return unless crop_meta_present?

    manipulate! do |img|
      x = model.crop_meta[:dreambook_bg][:x].to_i
      y = model.crop_meta[:dreambook_bg][:y].to_i
      w = model.crop_meta[:dreambook_bg][:width].to_i
      h = model.crop_meta[:dreambook_bg][:height].to_i

      img.crop "#{w}x#{h}+#{x}+#{y}"
      img
    end
  end

  def crop_meta_present?
    model.crop_meta && model.crop_meta[:dreambook_bg] && model.crop_meta[:dreambook_bg][:x].present?
  end
end
