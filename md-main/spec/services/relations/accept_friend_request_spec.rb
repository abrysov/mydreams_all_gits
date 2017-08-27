require 'rails_helper'

RSpec.describe Relations::AcceptFriendRequest do
  describe '.call' do
    let(:sender) { FactoryGirl.create :light_dreamer }
    let(:receiver) { FactoryGirl.create :light_dreamer }

    subject(:friends) { sender.friends }
    subject(:sender_followers) { sender.followers }
    subject(:subscribers) { sender.subscribers }

    before do
      FriendRequest.create sender: sender, receiver: receiver
      described_class.call sender, receiver
    end

    it 'adds friend' do
      expect(friends).to include receiver
    end

    it 'sets up subscription' do
      expect(subscribers).to include receiver
    end

    it 'removes friend request' do
      request = FriendRequest.find_by sender: sender, receiver: receiver
      expect(request).to be_nil
    end
  end
end
