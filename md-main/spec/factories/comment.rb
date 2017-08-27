FactoryGirl.define do
  factory :comment do
    body 'body'
    dreamer { FactoryGirl.create(:light_dreamer) }
    commentable { FactoryGirl.create(:light_post) }

    trait :deleted do
      deleted_at DateTime.now
    end
  end
end
