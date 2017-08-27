require 'rails_helper'

RSpec.describe LogAction::Management do
  let(:dreamer) { create :light_dreamer }
  let(:product) { create :product }

  context 'create logs' do
    before do
      described_class.call('create', product, dreamer)
    end

    it do
      log = ManagementLog.last

      expect(log.logable).to eq product
      expect(log.dreamer).to eq dreamer
      expect(log.action).to eq 'create'
    end
  end
end
