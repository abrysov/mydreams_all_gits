class CreateDreamCities < ActiveRecord::Migration
  def change
    create_table :dream_cities do |t|
      t.string :name
      t.string :meta
      t.string :code
      t.string :prefix
      t.string :important
      t.bigint :osm_id
      t.references :dream_country, index: true, foreign_key: true
      t.references :dream_region, index: true, foreign_key: true
      t.references :dream_district, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
