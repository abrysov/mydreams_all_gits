require 'rails_helper'

RSpec.describe Seed::Posts do
  describe '.call' do
    let(:dreamer) { create :light_dreamer }
    before do
      described_class.call(dreamer, true, 1)
      dreamer.reload
    end
    it { expect(dreamer.posts.count).to eq 1 }
    it { expect(dreamer.posts.last.photo).not_to be_nil }
  end
end
