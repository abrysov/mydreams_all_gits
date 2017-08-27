FactoryGirl.define do
  factory :purchase do
    dreamer
    destination { FactoryGirl.create(:dream) }
    product { FactoryGirl.create(:product) }
    amount { product.cost }
    comment { Faker::Lorem.sentence }
  end
end
