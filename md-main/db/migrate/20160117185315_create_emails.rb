class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :dreamer_id
      t.string :email
      t.boolean :confirmed, default: false
      t.boolean :sent, default: false
      t.boolean :deferral, default: false
      t.boolean :hard_bounce, default: false
      t.boolean :soft_bounce, default: false
      t.boolean :open, default: false
      t.boolean :click, default: false
      t.boolean :spam, default: false
      t.boolean :unsub, default: false
      t.boolean :reject, default: false

      t.timestamps null: false
    end
  end
end
