class CreateDreamHiddenTags < ActiveRecord::Migration
  def change
    create_table :dream_hidden_tags do |t|
      t.references :dream, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
