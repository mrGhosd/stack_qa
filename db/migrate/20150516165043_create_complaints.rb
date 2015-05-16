class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.belongs_to :user
      t.integer :complaintable_id, null: false, index: true
      t.string :complaintable_type, null: false, index: true
      t.timestamps
    end
  end
end
