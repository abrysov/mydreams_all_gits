class AddStatusToDreamer < ActiveRecord::Migration
  def change
    add_column :dreamers, :status, :string, default: nil
  end
end
