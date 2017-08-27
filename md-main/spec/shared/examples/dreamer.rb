require 'rails_helper'

RSpec.shared_examples 'dreamer' do
  describe 'instance methods' do
    it { is_expected.to respond_to :first_name }
    it { is_expected.to respond_to :last_name }
    it { is_expected.to respond_to :is_vip? }
    it { is_expected.to respond_to :online? }
    it { is_expected.to respond_to :avatar }
    it { is_expected.to respond_to :gender }
    it { is_expected.to respond_to :age }
    it { is_expected.to respond_to :dream_city }
    it { is_expected.to respond_to :send_to }
  end
end
