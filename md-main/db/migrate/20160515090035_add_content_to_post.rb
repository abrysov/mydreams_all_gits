class AddContentToPost < ActiveRecord::Migration
  def change
    add_column :posts, :content, :text
    add_reference :posts, :parent, index: true
  end
end
