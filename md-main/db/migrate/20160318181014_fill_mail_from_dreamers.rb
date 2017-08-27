class FillMailFromDreamers < ActiveRecord::Migration
  def change
    add_index :emails, :email, unique: true
    Dreamer.find_each do |dreamer|
      dreamer.emails.create(email: dreamer.email) if dreamer.emails.empty?
    end
  end
end
