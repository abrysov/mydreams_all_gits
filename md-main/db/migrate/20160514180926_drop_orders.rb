class DropOrders < ActiveRecord::Migration
  def change
    drop_table :transactions if table_exists? :transactions
    drop_table :accounts if table_exists? :accounts

    if table_exists? :order_items
      remove_foreign_key :order_items, :orders
      remove_foreign_key :order_items, :products

      drop_table :order_items
    end

    if table_exists? :orders
      remove_foreign_key :orders, :dreamers
      drop_table :orders
    end

    if table_exists? :product_properties
      remove_foreign_key :product_properties, :properties
      remove_foreign_key :product_properties, :products

      drop_table :product_properties
    end

    drop_table :properties if table_exists? :properties
    drop_table :products if table_exists? :products
  end
end
