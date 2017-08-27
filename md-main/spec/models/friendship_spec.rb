require 'rails_helper'

describe Friendship do
  describe 'validations' do
    context 'when incorrect friendship' do
      subject { described_class.create(member_ids: []).errors }
      it 'validates length of member_ids' do
        is_expected.to have_key :member_ids
      end
    end

    context 'when correct friendship' do
      let(:dreamer) { create :light_dreamer }
      let(:another_dreamer) { create :light_dreamer }
      subject { described_class.create(member_ids: [dreamer.id, another_dreamer.id]) }

      it 'creates friendship' do
        is_expected.to be_persisted
      end
    end
  end

  describe '#members' do
    let(:dreamer) { FactoryGirl.create :light_dreamer }
    let(:another_dreamer) { FactoryGirl.create :light_dreamer }
    let(:friendship) { Friendship.create(member_ids: [dreamer.id, another_dreamer.id]) }
    subject(:members) { friendship.members }
    subject(:members_count) { members.count }

    it 'includes correct members' do
      expect(members.to_a.sort).to eq [dreamer, another_dreamer].sort
    end
  end

  describe '#friend_for' do
    let(:dreamer) { FactoryGirl.create :light_dreamer }
    let(:another_dreamer) { FactoryGirl.create :light_dreamer }
    let(:friendship) { Friendship.create(member_ids: [dreamer.id, another_dreamer.id]) }
    subject { friendship.friend_for dreamer }

    it 'finds correct friend for dreamer' do
      is_expected.to eq another_dreamer
    end
  end
end
