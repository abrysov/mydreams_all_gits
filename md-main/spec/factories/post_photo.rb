# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_photo do
    photo { FactoryHelpers.uploaded_fixture_image }
  end
end
