class AddMemberIdsToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :member_ids, :integer, array: true
  end
end
