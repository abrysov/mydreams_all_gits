require 'rails_helper'

RSpec.describe Seed::Avatars do
  describe '.call' do
    let(:dreamer) { create :light_dreamer }
    before do
      described_class.call(dreamer, 2)
      dreamer.reload
    end
    it { expect(dreamer.avatars.count).to eq 2 }
  end
end
