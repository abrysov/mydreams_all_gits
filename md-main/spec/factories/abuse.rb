FactoryGirl.define do
  factory :abuse do
    abusable { FactoryGirl.create(%w{dream post photo}.shuffle.first) }
    text { Faker::Lorem.sentence }
    moderator { FactoryGirl.create(:dreamer, :moderator) }
  end
end
