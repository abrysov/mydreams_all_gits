require 'rails_helper'

RSpec.describe Seed::Certificates do
  describe '.call' do
    let(:dreamer) { create :light_dreamer }
    let(:dream) { create :dream, dreamer: dreamer }
    let(:certificate_type) { create :certificate_type }
    before do
      certificate_type
      dream
      described_class.call(dreamer, 2)
      dream.reload
    end
    it { expect(dream.certificates.count).to eq 2 }
  end
end
