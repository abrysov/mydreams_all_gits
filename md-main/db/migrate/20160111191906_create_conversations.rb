class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :member_ids, array: true, default: [], index: true

      t.timestamps null: false
    end
  end
end
