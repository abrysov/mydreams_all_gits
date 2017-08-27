FactoryGirl.define do
  factory :dream_region do
    name { Faker::Address.state }
    meta { Faker::Lorem.sentence }
    code { Faker::Address.state_abbr }
    dream_country
  end
end
