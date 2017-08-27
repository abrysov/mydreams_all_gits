require 'geoip'

class GeoipLocator

  def initialize(ip)
    @ip = ip
    @db = GeoIP.new(Rails.root.join('GeoLiteCity.dat'))
  end

  def city_name
    @db.city(@ip.to_s).try(:city_name)
  end

  def country_name
    @db.city(@ip.to_s).try(:country_name)
  end
end
