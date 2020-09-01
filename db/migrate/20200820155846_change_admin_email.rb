class ChangeAdminEmail < ActiveRecord::Migration
  def change
    change_column :admins, :email, :citext, null: false, default: ''
  end
end
