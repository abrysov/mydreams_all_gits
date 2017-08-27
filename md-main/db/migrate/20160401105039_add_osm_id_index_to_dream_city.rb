class AddOsmIdIndexToDreamCity < ActiveRecord::Migration
  def change
    add_index :dream_cities, :osm_id
  end
end
