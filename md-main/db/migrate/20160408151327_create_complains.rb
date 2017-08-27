class CreateComplains < ActiveRecord::Migration
  def change
    create_table :complains do |t|
      t.integer :complainer_id, references: :dreamer, index: :true
      t.integer :suspected_id, references: :dreamer, index: :true
      t.references :complainable, polymorphic: true, index: true
      t.string :state

      t.timestamps null: false
    end
  end
end
