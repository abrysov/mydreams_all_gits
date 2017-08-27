class CreateFeedback < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :dreamer_id, index: true, foreign_key: true
      t.integer :initiator_id, index: true, foreign_key: true
      t.integer :resource_id
      t.string :resource_type
      t.string :action
    end
  end
end
