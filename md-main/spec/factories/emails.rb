FactoryGirl.define do
  factory :email do
    dreamer
    sequence :email do |n|
      "#{(rand*1000).to_i}person#{n}@example.com"
    end
  end
end
