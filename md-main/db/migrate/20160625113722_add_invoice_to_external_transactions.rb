class AddInvoiceToExternalTransactions < ActiveRecord::Migration
  def change
    add_reference :external_transactions, :invoice, index: true
  end
end
