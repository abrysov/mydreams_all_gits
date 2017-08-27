class BaseSecureUploader < CarrierWave::Uploader::Base

  after :remove, :clear_uploader

  def clear_uploader
    @file = @filename = @original_filename = @cache_id = @version = @storage = nil
    begin
      model.send(:write_attribute, mounted_as, nil)
    rescue StandardError => e
      Rails.logger.info e.message
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{folder_name}"
  end

  def filename
    @name ||= "#{timestamp}-#{super}" if original_filename.present? and super.present?
  end

  private

  def folder_name
    hash = encode( model.id.to_s )
    4.times.map{ hash.slice!(0,8) }.join('/')
  end

  def timestamp
    var = :"@#{mounted_as}_timestamp"
    model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
  end

  def encode string
    Digest::MD5.hexdigest( string + salt )
  end

  def salt
    Dreams.config.images_salt
  end
end
