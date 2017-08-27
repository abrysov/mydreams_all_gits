class RemoveDreamerColumns < ActiveRecord::Migration
  def change
    remove_column :dreamers, :hide_dream_comments, :boolean
    remove_column :dreamers, :hide_diary_comments, :boolean
    remove_column :dreamers, :middle_name, :string
    remove_column :dreamers, :vip_ends, :datetime
  end
end
