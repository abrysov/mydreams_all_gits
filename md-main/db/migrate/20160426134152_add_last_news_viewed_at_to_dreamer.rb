class AddLastNewsViewedAtToDreamer < ActiveRecord::Migration
  def change
    add_column :dreamers, :last_news_viewed_at, :datetime
  end
end
