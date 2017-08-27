require 'rails_helper'

RSpec.describe CleanupOnlineDreamersWorker do
  describe '#perform' do
    let!(:stale) { create(:dreamer, online: true, last_reload_at: 2.days.ago) }
    let!(:fresh) { create(:dreamer, online: true, last_reload_at: 2.hours.ago) }

    it "Updates stale dreamer but doesn't touch fresh one" do
      subject.perform
      expect(stale.reload.online).to eq(false)
      expect(fresh.reload.online).to eq(true)
    end
  end
end
