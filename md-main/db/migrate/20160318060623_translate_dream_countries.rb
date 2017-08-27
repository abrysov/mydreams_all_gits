class TranslateDreamCountries < ActiveRecord::Migration
  def self.up
    DreamCountry.create_translation_table!({
                                             name: :string,
                                             meta: :string,
                                             alt_name: :string
                                           }, migrate_data: true)
  end

  def self.down
    DreamCountry.drop_translation_table! migrate_data: true
  end
end
