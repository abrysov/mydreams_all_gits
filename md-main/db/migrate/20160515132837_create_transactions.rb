class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :external_transactions do |t|
      t.references :account, index: true, foreign_key: true
      t.decimal :amount
      t.string :operation
      t.string :state
      t.string :gateway_id
      t.string :external_transaction_id
      t.integer :money
      t.string :currency

      t.timestamps null: false
    end

    create_table :purchase_transactions do |t|
      t.references :purchase, index: true, foreign_key: true
      t.references :account, index: true, foreign_key: true
      t.decimal :amount
      t.string :operation
      t.string :state

      t.timestamps null: false
    end
  end
end
