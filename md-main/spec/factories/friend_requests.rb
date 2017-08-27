FactoryGirl.define do
  factory :friend_request do
    association :sender, factory: :light_dreamer
    association :receiver, factory: :light_dreamer
  end
end
