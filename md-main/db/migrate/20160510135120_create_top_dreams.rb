class CreateTopDreams < ActiveRecord::Migration
  def change
    create_table :top_dreams do |t|
      t.string :title
      t.text :description
      t.text :photo
      t.string :locale
      t.integer :likes_count, default: 0
      t.integer :comments_count, default: 0
      t.integer :position, default: 0
      t.datetime :review_date
      t.boolean :ios_safe
      t.boolean :nsfw
      t.datetime :deleted_at
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
