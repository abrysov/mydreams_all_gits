class AddOsmIdIndexToDreamDistrict < ActiveRecord::Migration
  def change
    add_index :dream_districts, :osm_id
  end
end
