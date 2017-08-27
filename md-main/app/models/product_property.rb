class ProductProperty < ActiveRecord::Base
  belongs_to :product

  validates :key, :value, presence: true

  def certificate_name
    find_by(key: 'certificate_name').try(:value)
  end
end
