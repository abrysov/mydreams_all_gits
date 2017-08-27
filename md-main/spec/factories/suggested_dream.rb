# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :suggested_dream do
    dream
    receiver { FactoryGirl.create(:dreamer) }
    accepted false

    factory :accepted_suggested_dream do
      accepted true
    end
  end
end
