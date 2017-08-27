CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
    }
    config.fog_directory = Rails.application.secrets.attachment_directory
    config.asset_host = Rails.application.secrets.asset_host
    config.storage = :fog
    config.fog_attributes = {
      cache_control: "max-age=#{1.year.to_i}, must re-validate",
      expires: 1.year.from_now.httpdate
    }
  else
    config.storage = :file
  end
end
