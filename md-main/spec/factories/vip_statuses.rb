FactoryGirl.define do
  factory :vip_status do
    dreamer
    from_dreamer { FactoryGirl.create(:dreamer) }
    paid_at { 10.days.ago }
    completed_at { 20.days.since }
    duration 30
    comment { Faker::Lorem.sentence }
  end
end
