require 'rails_helper'

RSpec.describe Dreamer do
  it_behaves_like 'dreamer'

  let(:dreamer) { create :dreamer }
  subject { dreamer }

  describe 'amount' do
    it { expect(dreamer.account.amount).to eq 0 }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_uniqueness_of(:email).allow_blank }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:dream_country) }
    it { is_expected.to belong_to(:dream_city) }

    it do
      is_expected.to have_many(:activities).with_foreign_key(:owner_id)
        .class_name(Activity).dependent(:destroy)
    end
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:dreams).dependent(:destroy) }
    it do
      is_expected.to have_many(:dream_comments).through(:dreams).class_name(Comment)
        .source(:comments)
    end
    it { is_expected.to have_many(:likes) }
    it { is_expected.to have_many(:photos).dependent(:destroy) }
    it do
      is_expected.to have_many(:post_comments).through(:posts).class_name(Comment).source(:comments)
    end
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:suggested_dreams).with_foreign_key(:receiver_id) }
    it { is_expected.to have_many(:suggested_posts).with_foreign_key(:receiver_id) }

    it { is_expected.to have_many(:friend_requests).with_foreign_key(:receiver_id) }
    it do
      is_expected.to have_many(:outgoing_friend_requests).class_name(FriendRequest)
        .with_foreign_key(:sender_id)
    end

    it do
      is_expected.to have_many(:active_followings).class_name(Following)
        .with_foreign_key(:follower_id).dependent(:destroy)
    end
    it do
      is_expected.to have_many(:passive_followings).class_name(Following)
        .with_foreign_key(:followee_id).dependent(:destroy)
    end
    it { is_expected.to have_many(:followers).through(:passive_followings).source(:follower) }
    it { is_expected.to have_many(:followees).through(:active_followings).source(:followee) }
  end

  describe 'instance methods' do
    it { is_expected.to respond_to :friends }
    it { is_expected.to respond_to :new_followers }
  end

  describe 'Dreamerable' do
    describe '#online?' do
      context 'less than 5 minutes' do
        before { dreamer.update_attribute(:last_reload_at, 4.minutes.ago) }
        it { dreamer.online?.should be_truthy }
      end

      context 'more than 5 minutes' do
        before { dreamer.update_attribute(:last_reload_at, 6.minutes.ago) }
        it { dreamer.online?.should be_falsy }
      end
    end

    describe '#generate_new_password' do
      context 'with blank password' do
        before { dreamer.password = nil }
        xspecify do
          expect { dreamer.generate_new_password }.to change { dreamer.password }
        end
      end
    end
  end

  describe 'Messageable' do
    let!(:friend) { FactoryGirl.create(:dreamer) }
    let!(:other_friend) { FactoryGirl.create(:dreamer) }
    let!(:message1) { FactoryGirl.create(:message, receiver: friend, sender: dreamer) }
    let!(:message2) { FactoryGirl.create(:message, receiver: friend, sender: other_friend) }

    describe '#messages_with' do
      specify do
        friend.messages_with(dreamer).should be == [message1]
        friend.messages_with(other_friend).should be == [message2]
      end
    end
  end
end
