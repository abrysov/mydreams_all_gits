require 'rails_helper'

RSpec.describe Account::DreamsController do
  describe 'For signed in user' do
    let(:dream_params) { attributes_for :dream }
    let(:dreamer) { create :dreamer }
    before do
      sign_in dreamer
    end

    describe 'POST #create' do
      before do
        post :create, dream: dream_params
      end

      it { expect(response).to be_redirect }
      it { expect(Dream.where(title: dream_params[:title])).to exist }
      it { expect(Dream.last.photo.url).not_to be_nil }
      it { expect(Dream.last.read_attribute(:photo)).not_to be_nil }
      it 'create Activity' do
        expect(Activity.where(owner_id: dreamer.id,
                              trackable_type: 'Dream',
                              key: 'dream_create')).to exist
      end

      describe 'Notifications' do
        before do
          Relations::SendFriendRequest.call from: subscribed_dreamer, to: dreamer
          post :create, dream: dream_params
        end
        let(:subscribed_dreamer) { create :light_dreamer }
        let(:not_subscribed_dreamer) { create :light_dreamer }
        let(:notification) { Notification.where(initiator_id: dreamer.id) }
        let(:friend_notification) { Notification.where(dreamer_id: subscribed_dreamer.id) }
        let(:not_friend_notification) { Notification.where(dreamer_id: not_subscribed_dreamer.id) }

        it 'not create for not friend dreamer' do
          expect(not_friend_notification).not_to exist
        end
        it 'create for friend with dream_create key' do
          expect(friend_notification).to exist
          expect(friend_notification.first.action).to eq 'dream_create'
        end
      end
    end

    describe 'GET #index' do
      let(:dreamer) { create :light_dreamer }
      subject { get :index, dreamer_id: dreamer.id }
      it { is_expected.to be_success }
    end
  end
end
