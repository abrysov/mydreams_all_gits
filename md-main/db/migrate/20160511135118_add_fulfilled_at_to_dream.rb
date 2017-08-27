class AddFulfilledAtToDream < ActiveRecord::Migration
  def change
    add_column :dreams, :fulfilled_at, :datetime
  end
end
