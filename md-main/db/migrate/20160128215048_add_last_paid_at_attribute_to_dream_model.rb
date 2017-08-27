class AddLastPaidAtAttributeToDreamModel < ActiveRecord::Migration
  def change
    add_column :dreams, :last_paid_at, :datetime, default: nil
  end
end
