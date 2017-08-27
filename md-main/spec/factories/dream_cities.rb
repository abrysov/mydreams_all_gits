FactoryGirl.define do
  factory :dream_city do
    name { Faker::Address.city }
    meta { Faker::Lorem.sentence }
    code { Faker::Lorem.sentence }
    prefix { Faker::Lorem.sentence }
    important { Faker::Lorem.sentence }
    postcode { Faker::Address.postcode }
    dream_country
    dream_region
    dream_district
  end
end
