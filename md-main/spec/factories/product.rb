FactoryGirl.define do
  factory :product do
    name { Faker::Lorem.sentence }
    cost 10.50
    product_type 'vip'

    trait :locked do
      state 'locked'
    end

    trait :cert do
      product_type 'cert'
    end

    factory :product_vip do
      cost 900

      after(:create) do |product|
        create :product_property, :vip_month, product: product
      end
    end

    factory :gold_certificate do
      product_type 'cert'
      cost 100

      after(:create) do |product|
        create :certificate_type, name: 'gold', value: 10
        create :product_property, :gold_certificate, product: product
        create :product_property, :launches, product: product
      end
    end

    factory :special_rate do
      product_type 'special'
      cost 1

      after(:create) do |product|
        create :product_property, :gateway_id, product: product
        create :product_property, :gateway_rate, product: product
      end
    end

    factory :special_double_rate do
      product_type 'special'
      cost 1

      after(:create) do |product|
        create :product_property, :gateway_id, product: product
        create :product_property, :gateway_rate_double, product: product
      end
    end

    factory :inapp_appstore do
      product_type 'special'
      cost 1

      after(:create) do |product|
        create :product_property, :apple_product_id, product: product
        create :product_property, :gateway_appstore, product: product
        create :product_property, :gateway_rate_inapp, product: product
      end
    end
  end
end
