# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    file { FactoryHelpers::uploaded_fixture_image }
    caption { Faker::Lorem.sentence }
    dreamer
  end
end
