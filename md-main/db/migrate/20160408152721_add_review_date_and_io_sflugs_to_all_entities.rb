class AddReviewDateAndIoSflugsToAllEntities < ActiveRecord::Migration
  def change
    [:dreamers, :dreams, :photos, :posts, :comments].each do |table_name|
      change_table table_name do |t|
        t.datetime :review_date
        t.boolean  :ios_safe
        t.boolean  :nsfw
      end
    end
  end
end
