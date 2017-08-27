module SettingsHelpers
  def setup_settings
    Setting.create key: :vip_status_price, value: 100
    Setting.create key: :certificate_price, value: 5
  end
end
