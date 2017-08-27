FactoryGirl.define do
  factory :dream_district do
    name { Faker::Lorem.sentence }
    meta { Faker::Lorem.sentence }
    code { Faker::Lorem.sentence }
    dream_country
    dream_region
  end
end
