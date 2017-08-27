# DEPRICATED
class Setting < ActiveRecord::Base
  def self.key_value(key)
    find_by(key: key).try(:value)
  end

  def self.vip_status_price
    key_value(:vip_status_price).to_i
  end

  def self.certificate_price
    key_value(:certificate_price).to_i
  end

  def self.method_missing(method_id, *args, &block)
    key_value(method_id)
  end
end
