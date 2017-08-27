FactoryGirl.define do
  factory :conversation do
    member_ids { [generate(:integer), generate(:integer)] }
  end
end
