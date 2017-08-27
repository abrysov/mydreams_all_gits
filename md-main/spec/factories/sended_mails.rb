FactoryGirl.define do
  factory :sended_mail do
    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    format :html
    email
    dreamer
    status 'enqueued'
  end

end
