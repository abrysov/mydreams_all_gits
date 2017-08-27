class CreateAdPages < ActiveRecord::Migration
  def change
    create_table :ad_pages do |t|
      t.string :route
      t.references :banner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
