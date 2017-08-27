require 'rails_helper'

RSpec.describe Following do
  describe 'relations' do
    it { is_expected.to belong_to(:follower).class_name(Dreamer) }
    it { is_expected.to belong_to(:followee).class_name(Dreamer) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:follower) }
    it { is_expected.to validate_presence_of(:followee) }
    it { expect(create(:following)).to validate_uniqueness_of(:follower).scoped_to(:followee_id) }
  end
end
