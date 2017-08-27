class CreateAdBanners < ActiveRecord::Migration
  def change
    create_table :ad_banners do |t|
      t.string :image
      t.string :url
      t.boolean :active

      t.timestamps null: false
    end
  end
end
