class AddResponseToExternalTransaction < ActiveRecord::Migration
  # TODO: rename external_transaction_id?
  # TODO: response - json??

  def up
    remove_column :external_transactions, :money
    remove_column :external_transactions, :currency

    add_column :external_transactions, :response, :json
    add_column :external_transactions, :inc_money, :decimal
    add_column :external_transactions, :inc_currency, :string
    add_column :external_transactions, :out_money, :decimal
    add_column :external_transactions, :out_currency, :string
  end

  def down
    remove_column :external_transactions, :response
    remove_column :external_transactions, :inc_money
    remove_column :external_transactions, :inc_currency
    remove_column :external_transactions, :out_money
    remove_column :external_transactions, :out_currency

    add_column :external_transactions, :money, :integer
    add_column :external_transactions, :currency, :string
  end
end
