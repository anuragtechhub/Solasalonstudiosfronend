class GiveLeaseBooleansDefaultValues < ActiveRecord::Migration
  def change
    change_column :leases, :sola_provided_insurance, :boolean, default: false
    change_column :leases, :ach_authorized, :boolean, default: false
  end
end
