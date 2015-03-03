class AddTagsToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :tags, :text, array: true, default: []
  end
end
