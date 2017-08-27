class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :dreamer_id
      t.integer :subscriber_id

      t.timestamps null: false
    end

    add_index :subscriptions, [:dreamer_id, :subscriber_id], unique: true
  end
end
