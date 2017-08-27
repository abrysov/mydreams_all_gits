class TranslateDreamRegions < ActiveRecord::Migration
  def self.up
    DreamRegion.create_translation_table!({
                                            name: :string,
                                            meta: :string
                                          }, migrate_data: true)
  end

  def self.down
    DreamRegion.drop_translation_table! migrate_data: true
  end
end
