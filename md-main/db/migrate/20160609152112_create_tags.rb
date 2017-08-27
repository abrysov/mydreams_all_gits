class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, unique: true
      t.integer :parent_id, index: true
      t.boolean :active, default: :true

      t.timestamps null: false
    end
  end
end
