require 'rails_helper'

RSpec.describe Purchase do
  it { is_expected.to belong_to :dreamer }
  it { is_expected.to belong_to :product }

  context 'state' do
    it { is_expected.to have_state :pending }
    it do
      is_expected.to_not allow_event :to_complete
      is_expected.to_not allow_event :to_fail
      is_expected.to allow_event :to_processing
    end
  end
end
