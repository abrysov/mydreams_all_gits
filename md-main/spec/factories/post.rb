# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| Faker::Lorem.sentence << n }
    body { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    photo { FactoryHelpers::uploaded_fixture_image }
    dreamer
    comments_count 0
    likes_count 0
  end

  factory :light_post, class: Post do
    sequence(:title) { |n| Faker::Lorem.sentence << n }
    content { Faker::Lorem.sentence }
    dreamer { FactoryGirl.create(:light_dreamer) }
  end
end
