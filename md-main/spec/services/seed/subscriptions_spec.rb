require 'rails_helper'

RSpec.describe Seed::Subscriptions do
  describe '.call' do
    let(:dreamer) { create :light_dreamer }
    before do
      create :light_dreamer
      described_class.call(dreamer, 1)
      dreamer.reload
    end
    it { expect(dreamer.subscriptions_to_dreamer.count).to eq 1 }
  end
end
