class AddSummaryCertificateTypeIdToDreams < ActiveRecord::Migration
  def change
    add_column :dreams, :summary_certificate_type_id, :integer
  end
end
