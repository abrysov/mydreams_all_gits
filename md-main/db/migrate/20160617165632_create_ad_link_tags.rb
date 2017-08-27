class CreateAdLinkTags < ActiveRecord::Migration
  def change
    create_table :ad_link_tags do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :ad_link, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
