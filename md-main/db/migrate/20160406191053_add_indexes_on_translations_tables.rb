class AddIndexesOnTranslationsTables < ActiveRecord::Migration
  def change
    add_index :dream_city_translations, :name
  end
end
