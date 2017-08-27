class DropGifts < ActiveRecord::Migration
  def change
    drop_table :gifts
  end
end
