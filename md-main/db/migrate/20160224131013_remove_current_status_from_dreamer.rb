class RemoveCurrentStatusFromDreamer < ActiveRecord::Migration
  def change
    remove_column :dreamers, :current_status_id
  end
end
