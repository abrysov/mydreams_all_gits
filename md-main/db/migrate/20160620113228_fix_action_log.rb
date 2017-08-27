class FixActionLog < ActiveRecord::Migration
  def up
    rename_column :management_logs, :admin_id, :dreamer_id
    rename_column :moderator_logs, :moderator_id, :dreamer_id
  end

  def down
    rename_column :management_logs, :dreamer_id, :admin_id
    rename_column :moderator_logs, :dreamer_id, :moderator_id
  end
end
