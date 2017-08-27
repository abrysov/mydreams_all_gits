class CreateInternalAccount < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.decimal :amount, null: false, default: 0
      t.references :dreamer, index: true, foreign_key: true

      t.timestamps null: false
    end

    create_table :transactions do |t|
      t.decimal :amount
      t.string :operation
      t.string :state
      t.references :account, index: true, foreign_key: true
      t.decimal :before
      t.decimal :after
      t.integer :reason_id
      t.string :reason_type

      t.timestamps null: false
    end
  end
end
