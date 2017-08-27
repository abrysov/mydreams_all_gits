class RemoveAndRenameAttachmentFields < ActiveRecord::Migration
  def change
    remove_column :dreamers, :avatar, :text
    remove_column :dreamers, :page_bg, :text
    remove_column :dreamers, :dreambook_bg, :text
    remove_column :photos,   :file, :text
    remove_column :dreams,   :photo, :text
    remove_column :posts,    :photo, :text

    rename_column :dreamers, :avatar_new,       :avatar
    rename_column :dreamers, :page_bg_new,      :page_bg
    rename_column :dreamers, :dreambook_bg_new, :dreambook_bg
    rename_column :photos,   :file_new,         :file
    rename_column :dreams,   :photo_new,        :photo
    rename_column :posts,    :photo_new,        :photo
  end
end
