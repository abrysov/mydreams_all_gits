class AddTranslateToOfficialNmae < ActiveRecord::Migration
  def change
    add_column :dream_regions, :official_name, :string
  end
end
