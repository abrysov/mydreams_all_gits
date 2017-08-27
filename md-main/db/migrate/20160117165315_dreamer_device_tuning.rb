class DreamerDeviceTuning < ActiveRecord::Migration
  def change
    # Confirmable
    add_column :dreamers, :confirmation_token, :string
    add_column :dreamers, :confirmed_at, :datetime
    add_column :dreamers, :confirmation_sent_at, :datetime
    add_column :dreamers, :unconfirmed_email, :string

    # Lockable
    add_column :dreamers, :failed_attempts, :integer, default: 0
    add_column :dreamers, :unlock_token, :string
    add_column :dreamers, :locked_at, :datetime

    # Invitable
    add_column :dreamers, :invitation_token, :string
  end
end
