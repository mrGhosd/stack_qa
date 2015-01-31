class AddCommentType < ActiveRecord::Migration
  def change
    remove_index :comments, :question_id
    rename_column :comments, :question_id, :commentable_id
    add_index :comments, :commentable_id
    add_column :comments, :commentable_type, :string
    add_index :comments, :commentable_type
  end
end
