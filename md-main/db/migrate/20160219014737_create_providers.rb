class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.references :dreamer, index: true, foreign_key: true
      t.string :key
      t.string :uid
      t.text :meta

      t.timestamps null: false
    end
  end
end
