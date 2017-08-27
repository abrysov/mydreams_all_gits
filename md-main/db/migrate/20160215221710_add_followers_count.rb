class AddFollowersCount < ActiveRecord::Migration
  def change
    add_column :dreamers, :followers_count, :integer, default: 0
  end
end
