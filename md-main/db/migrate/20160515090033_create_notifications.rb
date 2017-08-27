class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :dreamer, index: true, foreign_key: true, null: false
      t.integer :initiator_id, foreign_key: true
      t.references :resource, polymorphic: true
      t.string :action

      t.timestamps null: false
    end
  end
end
