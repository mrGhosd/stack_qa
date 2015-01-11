class AddUserRoleField < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :role, default: 'user'
    end
    user = User.find(1)
    user.role = 'admin' if user
  end
end
