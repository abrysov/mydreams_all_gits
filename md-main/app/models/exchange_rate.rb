# == Schema Information
#
# Table name: exchange_rates
#
#  id         :integer          not null, primary key
#  currency1  :string           not null
#  currency2  :string           not null
#  rate       :float            not null
#  created_at :datetime
#  updated_at :datetime
#

class ExchangeRate < ActiveRecord::Base
  validates :currency1, :currency2, :rate, presence: true
end
