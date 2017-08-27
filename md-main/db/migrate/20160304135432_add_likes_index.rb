class AddLikesIndex < ActiveRecord::Migration
  def change
     add_index :likes, [:likeable_id, :likeable_type]
  end
end
