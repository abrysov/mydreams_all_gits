class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :dreamer, index: true
      t.integer :destination_dreamer_id
      t.integer :destination_id
      t.string :destination_type
      t.decimal :amount
      t.string :state
      t.string :comment
      t.references :product, index: true

      t.timestamps null: false
    end
  end
end
