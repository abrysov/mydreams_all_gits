FactoryGirl.define do
  factory :transaction do
    amount 100
    account { FactoryGirl.create(:account) }
    operation :refill
    association :reason, factory: :purchase_transaction

    trait :external do
      association :reason, factory: :external_transaction
    end
  end
end
