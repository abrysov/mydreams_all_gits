if Rails.env.production?
  Lens.configure do |config|
    config.app_key = 'def49844ae26b4bedd507503730d8c50bb844ff831263376f88be8a32f471b02'
  end
else
  Lens.configure do |config|
    config.app_key = 'd296669a8e5aabdd80eda1178839f762df89ef6b908ac7e0fd53b0f4694c55e0'
  end
end

