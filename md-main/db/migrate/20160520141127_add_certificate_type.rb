class AddCertificateType < ActiveRecord::Migration
  def up
    change_column :certificates, :certificate_type_id, :integer, null: true

    add_column :certificates, :certificate_name, :string
    add_column :certificates, :launches, :integer, null: false, default: 0
  end

  def down
    change_column :certificates, :certificate_type_id, :integer, null: false

    remove_column :certificates, :certificate_name
    remove_column :certificates, :launches
  end
end
