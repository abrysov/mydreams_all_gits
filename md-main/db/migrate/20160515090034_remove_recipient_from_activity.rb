class RemoveRecipientFromActivity < ActiveRecord::Migration
  def change
    remove_column :activities, :recipient_id, :integer
    remove_column :activities, :recipient_type, :string
  end
end
