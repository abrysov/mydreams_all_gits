require 'rails_helper'

RSpec.describe Seed::Likes do
  describe '.call' do
    let(:dreamer) { create :light_dreamer }
    before do
      create :dream, dreamer: dreamer
      create :top_dream
      create :post, dreamer: dreamer
      create :photo, dreamer: dreamer
      described_class.call(dreamer, 1)
      dreamer.reload
    end
    it { expect(dreamer.likes.count).to eq 1 }
  end
end
