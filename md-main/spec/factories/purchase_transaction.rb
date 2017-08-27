FactoryGirl.define do
  factory :purchase_transaction do
    amount 100
    account
    operation :buy

    trait :refill do
      operation :refill
    end
  end
end
