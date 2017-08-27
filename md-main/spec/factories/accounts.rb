FactoryGirl.define do
  factory :account do
    amount 1000.00
    dreamer { FactoryGirl.create(:light_dreamer) }
  end
end
