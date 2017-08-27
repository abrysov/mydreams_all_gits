class TranslateDreamCities < ActiveRecord::Migration
  def self.up
    DreamCity.create_translation_table!({
                                          name: :string,
                                          meta: :string,
                                          prefix: :string
                                        }, migrate_data: true)
  end

  def self.down
    DreamCity.drop_translation_table! migrate_data: true
  end
end
