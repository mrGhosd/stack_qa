class AddRateToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :rate, :integer, null: false, default: 0
    add_index :answers, :rate
  end
end
