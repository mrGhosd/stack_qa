class AddRateForQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :rate, :integer, null: false, default: 0
    add_column :questions, :views, :integer, null: false, default: 0
    add_index :questions, :rate
    add_index :questions, :views
  end
end
