class CreateAdPageBanners < ActiveRecord::Migration
  def change
    create_table :ad_page_banners do |t|
      t.references :ad_page, index: true, foreign_key: true
      t.references :banner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
