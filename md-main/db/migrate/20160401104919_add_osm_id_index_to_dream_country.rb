class AddOsmIdIndexToDreamCountry < ActiveRecord::Migration
  def change
    add_index :dream_countries, :osm_id
  end
end
