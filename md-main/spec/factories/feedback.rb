FactoryGirl.define do
  factory :feedback do
    dreamer
    association :initiator, factory: :dreamer
    resource { FactoryGirl.create(:comment) }
  end
end
