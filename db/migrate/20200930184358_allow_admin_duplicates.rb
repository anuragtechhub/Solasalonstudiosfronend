class AllowAdminDuplicates < ActiveRecord::Migration
  def change
    remove_index :admins, :email_address
    add_index :admins, :email_address
  end
end
