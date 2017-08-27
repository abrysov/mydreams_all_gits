FactoryGirl.define do
  factory :dreamer do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { password }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    gender 'male'
    birthday { 20.years.ago }
    dream_city
    dream_country
    visits_count 0
    terms_of_service true
    confirmed_at DateTime.now

    factory :twitter_dreamer do
      email { Faker::Internet.email }
      provider 'twitter'
      uid '3367314459'
    end

    factory :online_dreamer do
      last_reload_at { Time.zone.now }
    end

    factory :vip_dreamer do
      is_vip true
    end

    trait :celebrity_dreamer do
      celebrity true
    end

    trait :with_avatar do
      avatar { FactoryHelpers.uploaded_fixture_image }
    end

    trait :with_dreambook_bg do
      crop_meta { { dreambook_bg: { x: 100, y: 100, width: 400, height: 400 } } }
      dreambook_bg { FactoryHelpers.uploaded_fixture_image }
    end

    trait :male do
      gender 'male'
    end

    trait :female do
      gender 'female'
    end

    trait :young do
      birthday  { 10.years.ago }
    end

    trait :old do
      birthday  { 50.years.ago }
    end

    trait :project_dreamer do
      project_dreamer true
    end

    trait :moderator do
      role 'moderator'
    end

    trait :blocked do
      blocked_at DateTime.now
    end

    trait :unconfirmed do
      confirmed_at nil
    end

    trait :ios_safe do
      ios_safe true
    end

    trait :approved do
      review_date DateTime.now
    end

    factory :young_male_dreamer, traits: [:male, :young]
    factory :old_female_dreamer, traits: [:female, :old]
    factory :ios_safe_and_approved_dreamer, traits: [:ios_safe, :approved]

    trait :deleted_dreamer do
      deleted_at 5.minutes.ago
    end
  end

  factory :light_dreamer, class: Dreamer do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { password }
    first_name { Faker::Name.first_name }
    birthday { 20.years.ago }
    confirmed_at DateTime.now
    gender 'male'
  end
end
