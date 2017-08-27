require 'rails_helper'

RSpec.describe Seed::Cities do
  describe '.call' do
    let(:country) { create :dream_country, code: :ru }
    before do
      described_class.call(country, 2)
      country.reload
    end
    it { expect(country.dream_cities.count).to eq 2 }
  end
end
