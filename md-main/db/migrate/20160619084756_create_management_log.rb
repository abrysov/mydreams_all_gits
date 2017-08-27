class CreateManagementLog < ActiveRecord::Migration
  def change
    create_table :management_logs do |t|
      t.references :logable, polymorphic: true, index: true
      t.integer :admin_id, references: :dreamer, index: :true
      t.string :action

      t.timestamps null: false
    end
  end
end