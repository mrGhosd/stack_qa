class AddFieldsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.date :date_of_birth
      t.string :place_of_birth
      t.string :avatar
    end
  end
end
