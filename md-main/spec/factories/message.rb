# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    sender { FactoryGirl.create(:dreamer) }
    receiver { FactoryGirl.create(:dreamer) }
    message { Faker::Lorem.sentence }
    read false
    conversation { FactoryGirl.create(:conversation, member_ids: [sender.id, receiver.id].sort) }

    factory :read_message do
      read true
    end
  end
end
