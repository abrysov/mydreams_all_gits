# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :static_page do
    title_ru { Faker::Lorem.sentence }
    title_en { Faker::Lorem.sentence }
    body_ru { Faker::Lorem.sentence }
    body_en { Faker::Lorem.sentence }
    slug { Faker::Lorem.words.join('_') }
  end
end
