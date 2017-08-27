require 'rails_helper'

RSpec.describe Admin::Management::TransactionsController, type: :controller do
  describe 'true way' do
    let(:dreamer) { create :dreamer, :project_dreamer, role: :admin }
    let(:account) { create :account, dreamer: dreamer }
    let(:transaction) { create :transaction, account: account }

    context 'transaction list' do
      before do
        transaction
        sign_in dreamer
        get :index
      end

      it do
        is_expected.to respond_with :ok
        is_expected.to render_with_layout 'admin/management'
        is_expected.to render_template :index
      end
    end

    context 'show transaction' do
      before do
        transaction
        sign_in dreamer
        get :show, id: transaction.id
      end

      it do
        is_expected.to respond_with :ok
        is_expected.to render_with_layout 'admin/management'
        is_expected.to render_template :show
      end
    end
  end
end
