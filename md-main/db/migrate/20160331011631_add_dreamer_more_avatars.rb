class AddDreamerMoreAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.references :dreamer, index: true, foreign_key: true
      t.text :photo
      t.text :crop_meta
      t.datetime :created_at
      t.datetime :updated_at
      t.timestamps null: false
    end

    change_table :dreamers do |t|
      t.integer :current_avatar_id, default: 0, null: false
      t.text :crop_meta
    end
  end
end
