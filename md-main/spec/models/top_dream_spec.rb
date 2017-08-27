require 'rails_helper'

describe TopDream do
  describe '#set_position' do
    let!(:top_dream1) { FactoryGirl.create(:top_dream) }
    let!(:top_dream2) { FactoryGirl.create(:top_dream) }
    let!(:top_dream3) { FactoryGirl.create(:top_dream) }
    specify do
      top_dream2.position.should be == top_dream1.position + 1
      top_dream3.position.should be == top_dream2.position + 1
    end
  end
end
