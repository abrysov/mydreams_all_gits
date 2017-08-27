require 'rails_helper'

RSpec.describe ExtraDreamersController do
  describe 'For signed in user' do
    let(:dreamer) { FactoryGirl.create :light_dreamer }
    before { sign_in dreamer }

    describe 'DELETE destroy friendship' do
      let(:another_dreamer) { FactoryGirl.create :light_dreamer }
      subject { delete :destroy, id: another_dreamer.id }
      before do
        Friendship.create member_ids: [dreamer.id, another_dreamer.id]
        another_dreamer.subscribe_to(dreamer)
        dreamer.subscribe_to(another_dreamer)
      end

      it { is_expected.to redirect_to root_url }
      it { expect { subject }.to change { dreamer.friends.count }.by(-1) }
      it { expect { subject }.to change { another_dreamer.friends.count }.by(-1) }
      it 'remove subscription to friend' do
        expect(dreamer.follows?(another_dreamer)).to be true
      end
      it 'leave subscribe from friend' do
        expect { subject }.to change { Following.count }.by(-1)
        expect(another_dreamer.follows?(dreamer)).to be true
      end
    end

    describe 'POST request_friendship' do
      let(:another_dreamer) { FactoryGirl.create :light_dreamer }
      subject { post :request_friendship, id: another_dreamer.id }

      it { is_expected.to redirect_to root_url }
      it { expect { subject }.to change { dreamer.followees.count }.by(1) }
      it { expect { subject }.to change { another_dreamer.friend_requests.count }.by(1) }
      it 'create Feedback' do
        expect { subject }.to change { Feedback.count }.by(1)
      end

      context 'when friend request already created' do
        before { FriendRequest.create sender: another_dreamer, receiver: dreamer }

        it { expect { subject }.to change { dreamer.friends.count }.by(1) }
        it { expect { subject }.to change { another_dreamer.friends.count }.by(1) }
        it 'create Activity' do
          expect { subject }.to change { Activity.count }.by(1)
          expect(Activity.where(owner: dreamer, key: 'friendship_accept')).to exist
        end
      end

      context 'when request receiver already subscribed to sender' do
        before { another_dreamer.subscribe_to(dreamer) }

        it { expect { subject }.to change { dreamer.friends.count }.by(1) }
        it { expect { subject }.to change { dreamer.friends.count }.by(1) }
        it { expect { subject }.to change { another_dreamer.friends.count }.by(1) }
        it 'create Activity' do
          expect { subject }.to change { Activity.count }.by(1)
          expect(Activity.where(owner: another_dreamer, key: 'friendship_accept')).to exist
        end
      end
    end

    describe 'POST remove_subscription' do
      let(:another_dreamer) { FactoryGirl.create :light_dreamer }
      subject { post :remove_subscription, id: another_dreamer.id }
      before { dreamer.followees << another_dreamer }

      it { is_expected.to redirect_to root_url }
      it { expect { subject }.to change { dreamer.followees.count }.by(-1) }
    end

    describe 'POST remove_inverse_subscription' do
      let(:another_dreamer) { FactoryGirl.create :light_dreamer }
      subject { post :remove_inverse_subscription, id: another_dreamer.id }
      before { dreamer.followers << another_dreamer }

      it { is_expected.to redirect_to root_url }
      it { expect { subject }.to change { dreamer.followers.count }.by(-1) }
    end

    describe 'POST deny_request' do
      let(:another_dreamer) { FactoryGirl.create :light_dreamer }
      subject { post :deny_request, id: another_dreamer.id }

      context 'when outgoing request' do
        before { FriendRequest.create sender: dreamer, receiver: another_dreamer }

        it { is_expected.to redirect_to root_url }
        it { expect { subject }.to change { dreamer.outgoing_friend_requests.count }.by(-1) }
      end

      context 'when incoming request' do
        before { FriendRequest.create sender: another_dreamer, receiver: dreamer }

        it { is_expected.to redirect_to root_url }
        it { expect { subject }.to change { dreamer.friend_requests.count }.by(-1) }
        it { expect { subject }.not_to change { dreamer.followers.count } }
      end
    end

    describe 'POST accept_request' do
      let(:another_dreamer) { FactoryGirl.create :light_dreamer }
      subject { post :accept_request, id: another_dreamer.id }
      before do
        Relations::SendFriendRequest.call from: another_dreamer, to: dreamer
        another_dreamer.subscribe_to(dreamer)
      end

      it { is_expected.to redirect_to root_url }
      it { expect { subject }.to change { dreamer.friends.count }.by(1) }
      it { expect { subject }.to change { another_dreamer.friends.count }.by(1) }
      it 'create Activity' do
        expect { subject }.to change { Activity.count }.by(1)
        expect(Activity.where(owner: dreamer, key: 'friendship_accept')).to exist
      end
      it 'create Notifications' do
        expect { subject }.to change { Notification.count }.by(1)
        action = Notification.find_by(initiator_id: dreamer.id).action
        expect(action).to eq 'friendship_accept'
      end
    end

    describe 'POST subscribe' do
      let(:another_dreamer) { FactoryGirl.create :light_dreamer }
      subject { post :subscribe, id: another_dreamer.id }

      it { is_expected.to redirect_to root_url }
      it { expect { subject }.to change { dreamer.followees.count }.by(1) }
    end

    describe 'POST unsubscribe' do
      let(:another_dreamer) { FactoryGirl.create :light_dreamer }
      subject { post :unsubscribe, id: another_dreamer.id }
      before { dreamer.followees << another_dreamer }

      it { is_expected.to redirect_to root_url }
      it { expect { subject }.to change { dreamer.followees.count }.by(-1) }
    end
  end
end
