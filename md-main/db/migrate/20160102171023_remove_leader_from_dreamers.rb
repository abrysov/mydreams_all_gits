class RemoveLeaderFromDreamers < ActiveRecord::Migration
  def change
    remove_column :dreamers, :leader, type: :boolean
  end
end
