class CreateDreamComeTrueEmails < ActiveRecord::Migration
  def change
    create_table :dream_come_true_emails do |t|
      t.references :dream, index: true, foreign_key: true
      t.string :additional_text
      t.string :snapshot
      t.integer :sender_id
      t.string :state
      t.datetime :sended_at
      t.timestamps null: false
    end

    add_index :dream_come_true_emails, :sender_id
  end
end
