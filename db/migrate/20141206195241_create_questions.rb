class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :text
      t.boolean :is_closed, default: false
      t.timestamps
    end
  end
end
