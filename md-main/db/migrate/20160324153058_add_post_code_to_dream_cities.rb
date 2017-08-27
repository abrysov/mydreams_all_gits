class AddPostCodeToDreamCities < ActiveRecord::Migration
  def change
    add_column :dream_cities, :postcode, :string
  end
end
