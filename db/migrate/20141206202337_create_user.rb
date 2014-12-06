class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :surname
      t.string :name
      t.string :email, uniqueness: true
      t.string :password
      t.boolean :is_confirmed
      t.timestamps
      t.index :email
      t.index :password
    end
  end
end
