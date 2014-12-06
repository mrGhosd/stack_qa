class AddDefaultValueToConfirmedUserColumn < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.change :is_confirmed, :boolean, default: false
    end
  end
end
