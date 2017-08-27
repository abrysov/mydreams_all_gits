class AddDreamerReferencesToPostPhoto < ActiveRecord::Migration
  def change
    add_reference :post_photos, :dreamer, index: true, foreign_key: true
  end
end
