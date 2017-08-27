class SetDateForDeviseToDreamer < ActiveRecord::Migration
  def change
    Dreamer.update_all confirmation_sent_at: Date.today
  end
end
