class CreateModeratorLogs < ActiveRecord::Migration
  def change
    create_table :moderator_logs do |t|
      t.references :logable, polymorphic: true, index: true
      t.integer :moderator_id, references: :dreamer, index: :true
      t.string :action

      t.timestamps null: false
    end
  end
end
