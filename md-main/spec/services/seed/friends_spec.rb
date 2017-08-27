require 'rails_helper'

RSpec.describe Seed::Friends do
  describe '.call' do
    let(:dreamer) { create :light_dreamer }
    before do
      create :light_dreamer
      described_class.call(dreamer, 1)
      dreamer.reload
    end
    it { expect(dreamer.friends.count).to eq 1 }
  end
end
