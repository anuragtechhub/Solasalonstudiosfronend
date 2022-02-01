class ChangesToAdmins < ActiveRecord::Migration
  def change
    change_column :admins, :email_address, :citext, null: true
    change_column_default(:admins, :email_address, nil)
  end
end
