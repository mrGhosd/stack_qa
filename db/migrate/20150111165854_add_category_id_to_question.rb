class AddCategoryIdToQuestion < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.belongs_to :category, index: true
    end
  end
end
