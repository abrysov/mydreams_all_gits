# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :like do
    dreamer
    likeable { FactoryGirl.create(%w(dream top_dream photo).sample) }
  end
end
