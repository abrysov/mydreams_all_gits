class AddDreamerGender < ActiveRecord::Migration
  def change
    add_column :dreamers, :gender, :string, index: true

    Dreamer.where(gender_male: true).update_all(gender: 'male')
    Dreamer.where(gender_male: false).update_all(gender: 'female')
  end
end
