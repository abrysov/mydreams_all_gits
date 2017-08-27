require 'rails_helper'

RSpec.describe Relations::Unfollow do
  describe '.call' do
    let(:dreamer) { FactoryGirl.create :light_dreamer }
    let(:another_dreamer) { FactoryGirl.create :light_dreamer }

    subject { described_class.call dreamer, another_dreamer }

    context 'does not follow' do
      it { is_expected.not_to be_success }
      it { expect { subject }.not_to change { dreamer.followees.count } }
    end

    context 'successful' do
      before do
        dreamer.followees << another_dreamer
        another_dreamer.subscribers << dreamer
      end

      it { is_expected.to be_success }
      it { expect { subject }.to change { dreamer.followees.count }.by(-1) }
      it { expect { subject }.to change { another_dreamer.subscribers.count }.by(-1) }

      context 'when incoming friend request exists' do
        before { FriendRequest.create(sender: another_dreamer, receiver: dreamer) }

        it { expect { subject }.to change { dreamer.friend_requests.count}.by(-1) }
      end
    end
  end
end
