class CreateAdBannerTags < ActiveRecord::Migration
  def change
    create_table :ad_banner_tags do |t|
      t.references :ad_banner, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
