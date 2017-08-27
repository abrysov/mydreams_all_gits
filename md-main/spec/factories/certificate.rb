FactoryGirl.define do
  factory :certificate do
    association :certifiable, factory: :dream
    certificate_type
  end
end
