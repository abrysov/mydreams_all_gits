# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dream, aliases: [:everyone_allowed_dream] do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    dreamer
    photo { FactoryHelpers::uploaded_fixture_image }
    restriction_level 0
    comments_count 0

    trait :deleted do
      deleted_at Time.zone.now
    end

    factory :fulfilled_dream do
      came_true true
    end

    factory :friends_allowed_dream do
      restriction_level 1
    end

    factory :nobody_allowed_dream do
      restriction_level 2
    end
  end
end
