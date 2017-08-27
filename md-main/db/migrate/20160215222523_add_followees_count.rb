class AddFolloweesCount < ActiveRecord::Migration
  def change
    add_column :dreamers, :followees_count, :integer, default: 0
  end
end
