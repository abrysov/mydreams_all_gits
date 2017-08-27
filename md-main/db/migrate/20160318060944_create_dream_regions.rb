class CreateDreamRegions < ActiveRecord::Migration
  def change
    create_table :dream_regions do |t|
      t.string :name
      t.string :meta
      t.string :code
      t.bigint :osm_id
      t.references :dream_country, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
