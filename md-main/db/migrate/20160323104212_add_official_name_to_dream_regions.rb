class AddOfficialNameToDreamRegions < ActiveRecord::Migration
  def up
    DreamRegion.add_translation_fields! official_name: :string
  end

  def down
    remove_column :dream_region_translations, :official_name
  end
end
