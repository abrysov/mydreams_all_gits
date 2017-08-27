require 'rails_helper'

RSpec.describe Seed::Countries do
  describe '.call' do
    before do
      I18n.available_locales = [:en, :ru]
      described_class.call
    end
    it { expect(DreamCountry.count).to eq 2 }
  end
end
