class CreateDreamDistricts < ActiveRecord::Migration
  def change
    create_table :dream_districts do |t|
      t.string :name
      t.string :meta
      t.string :code
      t.bigint :osm_id
      t.references :dream_country, index: true, foreign_key: true
      t.references :dream_region, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
