class CreateAuthorization < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.belongs_to :user, index: true
      t.string :provider, index: true
      t.string :uid, index: true
    end
  end
end
