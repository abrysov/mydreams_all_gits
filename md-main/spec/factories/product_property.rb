FactoryGirl.define do
  factory :product_property do
    product

    trait :gold_certificate do
      key 'certificate_name'
      value 'gold'
    end

    trait :launches do
      key 'certificate_launches'
      value 10
    end

    trait :vip_month do
      key 'vip_duration'
      value 30
    end

    trait :gateway_id do
      key 'gateway_id'
      value 'robokassa'
    end

    trait :gateway_appstore do
      key 'gateway_id'
      value 'appstore'
    end

    trait :gateway_rate do
      key 'gateway_rate'
      value 1
    end

    trait :gateway_rate_double do
      key 'gateway_rate'
      value 2
    end

    trait :apple_product_id do
      key 'apple_product_id'
      value 'club.mydreams.MyDreams.product_id'
    end

    trait :gateway_rate_inapp do
      key 'gateway_rate'
      value 1000
    end
  end
end
