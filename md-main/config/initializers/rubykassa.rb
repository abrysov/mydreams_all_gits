Rubykassa.configure do |config|
  config.login = Rails.application.secrets.robokassa_login
  config.first_password = Rails.application.secrets.robokassa_first_password
  config.second_password = Rails.application.secrets.robokassa_second_password
  config.mode = :production
  config.http_method = :post
  config.xml_http_method = :post
end
