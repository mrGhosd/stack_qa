class CreateQuestionUsersTable < ActiveRecord::Migration
  def change
    create_table :question_users do |t|
      t.belongs_to :question
      t.belongs_to :user
      t.timestamps
    end
  end
end
