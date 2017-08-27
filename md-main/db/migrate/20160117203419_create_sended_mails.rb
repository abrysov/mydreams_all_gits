class CreateSendedMails < ActiveRecord::Migration
  def change
    create_table :sended_mails do |t|
      t.integer :email_id
      t.integer :dreamer_id
      t.string :external_id
      t.string :subject
      t.text :body
      t.string :format
      t.string :state

      t.timestamps null: false
    end
  end
end
