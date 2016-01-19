class AllowAdminsAndStylistsToHaveNullEncrPass < ActiveRecord::Migration
  def change
    change_column :admins, :encrypted_password, :string, :null => true
    change_column :stylists, :encrypted_password, :string, :null => true
  end
end
