class DenormolizeTables < ActiveRecord::Migration
  def change
    add_column :questions, :comments_count, :integer, default: 0
    add_index :questions, :comments_count

    add_column :questions, :answers_count, :integer, default: 0
    add_index :questions, :answers_count

    add_column :answers, :comments_count, :integer, default: 0
    add_index :answers, :comments_count

    add_column :users, :questions_count, :integer, default: 0
    add_index :users, :questions_count

    add_column :users, :answers_count, :integer, default: 0
    add_index :users, :answers_count

    add_column :users, :comments_count, :integer, default: 0
    add_index :users, :comments_count
  end
end
