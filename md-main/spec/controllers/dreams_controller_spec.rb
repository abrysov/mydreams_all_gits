require 'rails_helper'

RSpec.describe DreamsController do
  describe '#show' do
    let(:dream) { create :dream }
    subject { get :show, id: dream.id }

    it { is_expected.to be_success }
  end

  describe '#show top_dream' do
    let(:dream) { create :top_dream }
    subject { get :show, id: dream.id }

    it { is_expected.to be_success }
  end
end
