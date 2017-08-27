FactoryGirl.define do
  factory :dream_come_true_email do
    dream
    association :sender, factory: :light_dreamer
    additional_text 'test'
  end
end
