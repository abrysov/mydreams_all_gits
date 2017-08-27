class DropDreamerProfile < ActiveRecord::Migration
  def change
    drop_table :dreamer_profiles
  end
end
