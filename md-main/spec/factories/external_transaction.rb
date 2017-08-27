FactoryGirl.define do
  factory :external_transaction do
    amount { rand(1000) }
    account
    operation :refill
    gateway_id 'robokassa'

    trait :rollback do
      operation :rollback
    end

    trait :robokassa_paid do
      external_transaction_id 'invoiceId'
      money { rand(100) }
      currency 'RUB'
    end

    trait :refill do
      after(:create) do |external|
        create :transaction, reason: external, amount: external.amount,
                             operation: external.operation, account: external.account
      end
    end
  end
end
