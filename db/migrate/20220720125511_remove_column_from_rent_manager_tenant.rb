class RemoveColumnFromRentManagerTenant < ActiveRecord::Migration
  def change
    remove_column :rent_manager_tenants, :move_in_at
    remove_column :rent_manager_tenants, :move_out_at
  end
end
