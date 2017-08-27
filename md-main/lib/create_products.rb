class CreateProducts
  def self.call
    certificates = [
      { id: 1, name: 'bronze', value: 1 },
      { id: 2, name: 'silver', value: 5 },
      { id: 3, name: 'gold', value: 10 },
      { id: 4, name: 'platinum', value: 50 },
      { id: 5, name: 'vip', value: 100 },
      { id: 6, name: 'presidential', value: 250 },
      { id: 7, name: 'imperial', value: 500 }
    ]

    certificates.map do |cert|
      amount = Setting.certificate_price * cert[:value]
      product = Product.create! name: cert[:name], cost: amount, product_type: :cert
      ProductProperty.create! product: product, key: 'certificate_name', value: cert[:name]
      ProductProperty.create! product: product, key: 'certificate_launches', value: cert[:value]
    end

    product = Product.create! name: 'Vip status', cost: 2000, product_type: :vip
    ProductProperty.create! product: product, key: 'vip_duration', value: 30

    Product.create! name: 'robokassa coins', cost: 1, product_type: :special

    Rails.logger.info 'work done'
    puts 'work done'
  end
end
