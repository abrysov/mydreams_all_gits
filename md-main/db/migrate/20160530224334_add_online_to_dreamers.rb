class AddOnlineToDreamers < ActiveRecord::Migration
  def change
    add_column :dreamers, :online, :boolean
  end
end
