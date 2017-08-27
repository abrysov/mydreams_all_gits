require 'rails_helper'

RSpec.describe Relations::RemoveFriend do
  describe '.call' do
    let(:dreamer) { FactoryGirl.create :light_dreamer }
    let(:another_dreamer) { FactoryGirl.create :light_dreamer }

    subject(:friends) { dreamer.friends }
    subject(:followers) { dreamer.followers }

    before do
      Friendship.create member_ids: [dreamer.id, another_dreamer.id]
      another_dreamer.subscribe_to(dreamer)
      dreamer.subscribe_to(another_dreamer)

      described_class.call dreamer, another_dreamer
    end

    it 'removes friend' do
      expect(friends).not_to include another_dreamer
    end

    it 'moves former friend to followers' do
      expect(dreamer.subscribers).to include another_dreamer
    end

    it 'removes subscription to former friend' do
      expect(another_dreamer.subscribers).not_to include dreamer
    end
  end
end
