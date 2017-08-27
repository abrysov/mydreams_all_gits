FactoryGirl.define do
  factory :banner do
    link 'http://google.com'
    image { FactoryHelpers.uploaded_fixture_image }
    date_start { DateTime.now - 1.day }
    date_end { DateTime.now + 1.day }
    link_hash { Digest::MD5.new.update(link) }

    trait :with_expired_date do
      date_end { DateTime.now - 1.day }
    end
  end
end
