require 'rails_helper'

RSpec.describe Account::ActivitiesController, type: :controller do
  describe '#index' do
    let(:dreamer) { create :dreamer }
    before { sign_in dreamer }
    subject { get :index }

    it { is_expected.to be_success }
  end
end
