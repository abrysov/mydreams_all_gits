class AddMessageViewedIds < ActiveRecord::Migration
  def change
    add_column :messages, :viewed_ids, :integer, array: true
  end
end
