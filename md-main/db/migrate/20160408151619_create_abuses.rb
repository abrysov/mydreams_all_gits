class CreateAbuses < ActiveRecord::Migration
  def change
    create_table :abuses do |t|
      t.references :abusable, polymorphic: true, index: true
      t.integer :moderator_id, references: :dreamer, index: :true
      t.integer :notify_id, references: :dreamer, index: :true
      t.text :text
      t.string :state
      t.references :complain, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
