class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :cost
      t.string :product_type
      t.string :state

      t.timestamps null: false
    end

    create_table :product_properties do |t|
      t.references :product, index: true, foreign_key: true
      t.string :key
      t.string :value

      t.timestamps null: false
    end
  end
end
