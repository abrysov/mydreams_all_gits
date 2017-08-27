FactoryGirl.define do
  factory :certificate_type do
    sequence(:name) { |n| "type #{n}" }
    value { rand(100) }
  end
end
