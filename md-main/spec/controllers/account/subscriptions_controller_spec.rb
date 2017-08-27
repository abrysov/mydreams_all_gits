require 'rails_helper'

RSpec.describe Account::SubscriptionsController do
  let(:dreamer) { create :light_dreamer }
  before { sign_in dreamer }

  describe 'GET #index' do
    context 'when subscriptions' do
      subject { get :index, dreamer_id: dreamer.id, subscriptions: true }

      # NOTE: remove check http status when redirect on RecordNotFound fixed
      it { is_expected.to have_http_status :ok }
      it { is_expected.to be_success }
    end

    context 'when not subscriptions' do
      subject { get :index, dreamer_id: dreamer.id }

      # NOTE: remove check http status when redirect on RecordNotFound fixed
      it { is_expected.to have_http_status :ok }
      it { is_expected.to be_success }
    end
  end
end
