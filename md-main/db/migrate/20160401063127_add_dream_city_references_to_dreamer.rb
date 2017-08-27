class AddDreamCityReferencesToDreamer < ActiveRecord::Migration
  def change
    add_reference :dreamers, :dream_city, index: true
  end
end
