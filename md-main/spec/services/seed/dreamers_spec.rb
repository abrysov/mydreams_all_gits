require 'rails_helper'

RSpec.describe Seed::Dreamers do
  describe '.call' do
    let(:country) { create :dream_country, code: :ru }
    before do
      described_class.call(country, 2)
      country.reload
    end
    it { expect(country.dreamers.count).to eq 2 }
  end
end
