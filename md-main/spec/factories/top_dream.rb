# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :top_dream do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    photo { FactoryHelpers::uploaded_fixture_image }
  end
end
