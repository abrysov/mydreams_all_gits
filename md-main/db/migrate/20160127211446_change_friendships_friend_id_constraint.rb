class ChangeFriendshipsFriendIdConstraint < ActiveRecord::Migration
  def change
    change_column :friendships, :friend_id, :integer, null: true
  end
end
