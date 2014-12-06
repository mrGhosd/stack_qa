class AddConnectionToQuestionModel < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.belongs_to :user
      t.index :title
      t.index :is_closed
    end
  end
end
