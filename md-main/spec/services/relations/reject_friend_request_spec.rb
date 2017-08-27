require 'rails_helper'

RSpec.describe Relations::RejectFriendRequest do
  describe '.call' do
    let(:dreamer) { FactoryGirl.create :light_dreamer }
    let(:another_dreamer) { FactoryGirl.create :light_dreamer }
    subject { -> { described_class.call dreamer, another_dreamer } }
    before { FriendRequest.create sender: dreamer, receiver: another_dreamer }

    it { is_expected.to change { FriendRequest.count }.by(-1) }
  end
end
