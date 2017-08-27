class AddRoleToDreamer < ActiveRecord::Migration
  def change
    add_column :dreamers, :role, :string
  end
end
