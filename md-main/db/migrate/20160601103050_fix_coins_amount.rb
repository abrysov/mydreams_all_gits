class FixCoinsAmount < ActiveRecord::Migration
  def tables
    [:external_transactions, :transactions, :purchase_transactions, :accounts, :purchases]
  end

  def up
    tables.each do |table_name|
      change_column table_name, :amount, :integer
    end

    change_column :products, :cost, :integer

    change_column :transactions, :before, :integer
    change_column :transactions, :after, :integer
  end

  def down
    tables.each do |table_name|
      change_column table_name, :amount, :decimal
    end

    change_column :products, :cost, :decimal

    change_column :transactions, :before, :decimal
    change_column :transactions, :after, :decimal
  end
end
