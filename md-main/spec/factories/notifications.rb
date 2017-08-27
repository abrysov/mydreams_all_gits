FactoryGirl.define do
  factory :notification do
    dreamer
    association :initiator, factory: :dreamer
    resource { FactoryGirl.create(%w(dream dreamer certificate).sample) }

    factory :notification_with_certificate do
      resource { FactoryGirl.create(:certificate) }
      action 'gift_self'
    end

    factory :notification_with_deleted_dreamer do
      resource { FactoryGirl.create(:dreamer, :deleted_dreamer) }
      action 'dreamer_deleted'
    end

    factory :notification_with_dream do
      resource { FactoryGirl.create(:dream) }
      action 'create_dream'
    end
  end
end
