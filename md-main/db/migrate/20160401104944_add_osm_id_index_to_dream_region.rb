class AddOsmIdIndexToDreamRegion < ActiveRecord::Migration
  def change
    add_index :dream_regions, :osm_id
  end
end
