# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :friendship do
    dreamer
    friend { FactoryGirl.create(:dreamer) }
    accepted_at nil

    before(:create) do |friendship|
      friendship.member_ids = [friendship.dreamer.id, friendship.friend.id]
    end

    factory :accepted_friendship do
      accepted_at { Time.zone.now }
    end
  end
end
