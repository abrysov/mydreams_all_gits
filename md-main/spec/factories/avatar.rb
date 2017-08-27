FactoryGirl.define do
  factory :avatar do
    dreamer
    photo { FactoryHelpers.uploaded_fixture_image }
    crop_meta { { x: 100, y: 100, width: 400, height: 400 } }
  end
end
