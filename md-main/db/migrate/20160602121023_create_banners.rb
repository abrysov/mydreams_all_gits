class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :image
      t.string :link
      t.string :name
      t.references :advertiser
      t.datetime :date_start
      t.datetime :date_end
      t.integer :show_count, default: 0
      t.integer :cross_count, default: 0
      t.string :link_hash

      t.timestamps null: false
    end
  end
end
