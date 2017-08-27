class CreateBlockedUsers < ActiveRecord::Migration
  def change
    create_table :blocked_users do |t|
      t.references :dreamer, index: true, foreign_key: true
      t.integer :moderator_id, references: :dreamer, index: :true
      t.integer :abuse_id, index: true
      t.text :text

      t.timestamps null: false
    end
  end
end
