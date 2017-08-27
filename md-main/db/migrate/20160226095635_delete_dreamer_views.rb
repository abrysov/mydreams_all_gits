class DeleteDreamerViews < ActiveRecord::Migration
  def change
    drop_table :dreamer_views
  end
end
