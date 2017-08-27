class TranslateDreamDisctricts < ActiveRecord::Migration
  def self.up
    DreamDistrict.create_translation_table!({
                                              name: :string,
                                              meta: :string
                                            }, migrate_data: true)
  end

  def self.down
    DreamDistrict.drop_translation_table! migrate_data: true
  end
end
