class AddTimestampsToFeedbacks < ActiveRecord::Migration
  def change
    add_timestamps(:feedbacks)
  end
end
