class AddCropDreamPhoto < ActiveRecord::Migration
  def change
    add_column :dreams, :photo_crop, :text
  end
end
