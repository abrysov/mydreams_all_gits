class AddDreamCountryReferencesToDreamer < ActiveRecord::Migration
  def change
    add_reference :dreamers, :dream_country, index: true
  end
end
