class AddLaunchesCountToDreams < ActiveRecord::Migration
  def change
    add_column :dreams, :launches_count, :integer, default: 0
  end
end
