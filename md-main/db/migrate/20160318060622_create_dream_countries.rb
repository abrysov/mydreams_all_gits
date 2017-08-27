class CreateDreamCountries < ActiveRecord::Migration
  def change
    create_table :dream_countries do |t|
      t.string :name
      t.string :alt_name
      t.string :meta
      t.string :code
      t.integer :number
      t.bigint :osm_id

      t.index :number
      t.timestamps null: false
    end
  end
end
