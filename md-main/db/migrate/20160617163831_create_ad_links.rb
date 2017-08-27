class CreateAdLinks < ActiveRecord::Migration
  def change
    create_table :ad_links do |t|
      t.string :url
      t.boolean :active

      t.timestamps null: false
    end
  end
end
