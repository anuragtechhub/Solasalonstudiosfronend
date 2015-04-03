class AddFranchiseeToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :franchisee, :boolean
  end
end
