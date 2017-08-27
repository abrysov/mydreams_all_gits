FactoryGirl.define do
  factory :following do
    association :follower, factory: :light_dreamer
    association :followee, factory: :light_dreamer

    trait :viewed do
      viewed_at { Time.zone.now }
    end
  end
end
