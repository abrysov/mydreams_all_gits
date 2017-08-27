require 'rails_helper'

RSpec.describe Seed::Dreams do
  describe '.call' do
    let(:dreamer) { create :light_dreamer }
    before do
      described_class.call(dreamer, 2)
      dreamer.reload
    end
    it { expect(dreamer.dreams.count).to eq 2 }
  end
end
