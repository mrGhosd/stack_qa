class AddUserIdToRedactorAssets < ActiveRecord::Migration
  def change
    add_column :redactor_assets, :user_id, :integer, index: true
  end
end
