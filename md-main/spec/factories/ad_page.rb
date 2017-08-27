FactoryGirl.define do
  factory :ad_page do
    route '/feed'

    trait :with_banner do
      after(:create) do |ad_page|
        ad_page.banners << create(:banner)
      end
    end

    trait :with_expired_banner do
      after(:create) do |ad_page|
        ad_page.banners << create(:banner, :with_expired_date)
      end
    end

    trait :with_two_banners do
      after(:create) do |ad_page|
        2.times { ad_page.banners << create(:banner) }
      end
    end

    factory :ad_page_with_valid_and_expired_banner, traits: [:with_banner, :with_expired_banner]
  end
end
