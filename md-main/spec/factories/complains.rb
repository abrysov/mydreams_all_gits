FactoryGirl.define do
  factory :complain do
    complainer { FactoryGirl.create(:dreamer) }
    suspected { FactoryGirl.create(:dreamer) }
    complainable { FactoryGirl.create(%w{dream post photo}.shuffle.first) }
    state { Faker::Lorem.word }
  end
end
