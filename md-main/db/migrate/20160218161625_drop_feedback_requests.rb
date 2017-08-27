class DropFeedbackRequests < ActiveRecord::Migration
  def change
    drop_table :feedback_requests
  end
end
