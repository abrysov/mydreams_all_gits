class SnapshotUploader < BaseSecureUploader
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  def extension_white_list
    %w{png jpg jpeg}
  end
end
