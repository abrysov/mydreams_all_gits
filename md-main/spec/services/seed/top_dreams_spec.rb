require 'rails_helper'

RSpec.describe Seed::TopDreams do
  describe '.call' do
    before { described_class.call(2) }
    it { expect(TopDream.count).to eq 2 }
  end
end
