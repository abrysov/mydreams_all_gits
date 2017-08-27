require 'rails_helper'

RSpec.describe WelcomeController do
  describe 'GET #index' do
    subject { get :index }
    before { create :light_dreamer }

    context 'when dreamer is guest' do
      it { is_expected.to be_success }
      # NOTE: remove http status check when redirecting on RecordNotFound will be fixed
      it { is_expected.to have_http_status :ok }
    end

    context 'when dreamer is signed in' do
      before { sign_in create(:light_dreamer) }

      it { is_expected.to be_success }
      # NOTE: remove http status check when redirecting on RecordNotFound will be fixed
      it { is_expected.to have_http_status :ok }
    end
  end
end
