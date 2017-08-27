require 'rails_helper'

RSpec.describe Product do
  it { is_expected.to have_many :purchases }
  it { is_expected.to have_many :properties }

  context 'state' do
    it { is_expected.to have_state :active }
    it do
      is_expected.to_not allow_event :activate
      is_expected.to allow_event :lock
    end
  end
end
