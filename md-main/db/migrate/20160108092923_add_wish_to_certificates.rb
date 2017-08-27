class AddWishToCertificates < ActiveRecord::Migration
  def change
  	add_column :certificates, :wish, :text
  end
end
