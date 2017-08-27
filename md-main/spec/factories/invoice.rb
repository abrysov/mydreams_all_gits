FactoryGirl.define do
  factory :invoice do
    dreamer
    amount { rand(1000) }

    trait :self_vip_type do
      payment_type Invoice::VIP_SELF_TYPE
    end

    trait :gift_vip_type do
      payment_type Invoice::VIP_GIFT_TYPE
    end

    trait :for_certificate do
      payment_type Invoice::CERTIFICATE_TYPE
      association :payable, factory: :certificate
    end
  end
end
