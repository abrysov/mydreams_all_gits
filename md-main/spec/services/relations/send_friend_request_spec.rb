require 'rails_helper'

RSpec.describe Relations::SendFriendRequest do
  describe '.call' do
    let(:sender) { FactoryGirl.create :light_dreamer }
    let(:receiver) { FactoryGirl.create :light_dreamer }

    subject(:receiver_followers) { receiver.followers }
    subject(:receiver_subscribers) { receiver.subscribers }
    subject(:request) { FriendRequest.find_by sender: sender, receiver: receiver }
    subject(:activity) do
      Activity.find_by owner: sender, trackable: receiver, key: 'friendship_request'
    end

    subject(:send_friend_request) { described_class.call from: sender, to: receiver }

    it 'follows receiver' do
      send_friend_request
      expect(receiver_followers).to include sender
    end

    it 'creates friend request' do
      send_friend_request
      expect(request).to be_present
    end

    it 'subscribes to receiver' do
      send_friend_request
      expect(receiver.subscribers).to include sender
    end

    it 'create Feedback' do
      expect { send_friend_request }.to change { Feedback.count }.by(1)
    end

    context 'when counter friend request exists' do
      before { FriendRequest.create!(sender: receiver, receiver: sender) }
      subject(:receiver_friends) { receiver.friends }

      it 'accepts counter friend request' do
        send_friend_request
        expect(receiver_friends).to include sender
      end

      it 'does not create new friend request' do
        expect { send_friend_request }.to change { FriendRequest.count }.by(-1)
      end
    end
  end
end
