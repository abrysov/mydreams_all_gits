class AddNewUploadAttributes < ActiveRecord::Migration
  def change
    add_column :dreamers, :avatar_new, :string
    add_column :dreamers, :page_bg_new, :string
    add_column :dreamers, :dreambook_bg_new, :string
    add_column :dreams, :photo_new, :string
    add_column :posts, :photo_new, :string
    add_column :photos, :file_new, :string
    add_column :attachments, :file_new, :string
    add_column :backgrounds, :file_new, :string
  end
end
