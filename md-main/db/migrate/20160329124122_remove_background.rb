class RemoveBackground < ActiveRecord::Migration
  def change
    drop_table :backgrounds
  end
end
