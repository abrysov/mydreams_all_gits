# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dreamer_country do
    name_ru { Faker::Lorem.sentence }
    name_en { Faker::Lorem.sentence }
  end
end
