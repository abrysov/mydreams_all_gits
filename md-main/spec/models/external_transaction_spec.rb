require 'rails_helper'

RSpec.describe ExternalTransaction do
  it { is_expected.to belong_to :account }
  it { is_expected.to have_one :reason_transaction }

  context 'state' do
    it { is_expected.to have_state :pending }
    it do
      is_expected.to allow_event :to_complete
      is_expected.to allow_event :to_fail
    end
  end
end
