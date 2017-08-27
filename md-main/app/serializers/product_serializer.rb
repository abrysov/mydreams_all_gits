class ProductSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :cost
  attribute :product_type
  attribute :properties

  def properties
    object.properties.inject({}) do |acc, prop|
      acc[prop.key] = prop.value
      acc
    end
  end
end
