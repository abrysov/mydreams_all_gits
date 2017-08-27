# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    file { FactoryHelpers::uploaded_fixture_image }
    attachmentable { FactoryGirl.create(:message) }
  end
end
