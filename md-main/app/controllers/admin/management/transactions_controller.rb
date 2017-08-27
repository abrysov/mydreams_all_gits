class Admin::Management::TransactionsController < Admin::Management::ApplicationController
  def index
    @transactions = ::Purchases::Transactions.management(params).
                    preload(:account, :reason).
                    page(page).
                    per(per_page)
  end

  # TODO: show dreamer transaction?
  def show
    @transaction = Transaction.find params[:id]
  end
end
