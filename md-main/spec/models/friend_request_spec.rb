require 'rails_helper'

RSpec.describe FriendRequest do
  describe 'relations' do
    it { is_expected.to belong_to(:sender).class_name(Dreamer) }
    it { is_expected.to belong_to(:receiver).class_name(Dreamer) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :sender }
    it { is_expected.to validate_presence_of :receiver }

    # NOTE: because of https://github.com/thoughtbot/shoulda-matchers/issues/535
    it do
      expect(create(:friend_request)).to validate_uniqueness_of(:sender).scoped_to(:receiver_id)
    end
  end
end
