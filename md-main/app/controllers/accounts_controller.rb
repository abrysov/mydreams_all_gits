class AccountsController < ApplicationController
  before_filter :authenticate_dreamer!

  def buy
  end

  def history
    @operation_history = current_dreamer.account.transactions.completed.
                         includes(:reason).order(created_at: :desc)
  end
end
