class RenameFirstNameAndLastNameToFnameAndLname < ActiveRecord::Migration
  def change
    rename_column :stylists, :first_name, :f_name
    rename_column :stylists, :last_name, :l_name
  end
end
