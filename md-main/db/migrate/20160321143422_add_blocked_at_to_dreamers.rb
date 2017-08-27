class AddBlockedAtToDreamers < ActiveRecord::Migration
  def change
    add_column :dreamers, :blocked_at, :datetime
  end
end
