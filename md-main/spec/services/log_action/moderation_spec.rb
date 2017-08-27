require 'rails_helper'

RSpec.describe LogAction::Moderation do
  let(:dreamer) { create :light_dreamer }
  let(:dream) { create :dream }

  context 'create logs' do
    before do
      described_class.call('create', dream, dreamer)
    end

    it do
      log = ModeratorLog.last

      expect(log.logable).to eq dream
      expect(log.dreamer).to eq dreamer
      expect(log.action).to eq 'create'
    end
  end
end
