require 'rails_helper'

RSpec.describe Admin::Management::LockedsController, type: :controller do
  describe 'true way' do
    let(:dreamer) { create :dreamer, :project_dreamer, role: :admin }

    context 'locked products list' do
      before do
        sign_in dreamer
        get :index
      end

      it do
        is_expected.to respond_with :ok
        is_expected.to render_with_layout 'admin/management'
        is_expected.to render_template :index
      end
    end
  end
end
