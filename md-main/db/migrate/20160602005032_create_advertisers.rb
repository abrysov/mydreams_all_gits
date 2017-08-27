class CreateAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
