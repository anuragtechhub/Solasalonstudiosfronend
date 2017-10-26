class AddFourRecurringChargesToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :recurring_charge_1_id, :integer
    add_column :leases, :recurring_charge_2_id, :integer
    add_column :leases, :recurring_charge_3_id, :integer
    add_column :leases, :recurring_charge_4_id, :integer

    add_index :leases, :recurring_charge_1_id
    add_index :leases, :recurring_charge_2_id
    add_index :leases, :recurring_charge_3_id
    add_index :leases, :recurring_charge_4_id
  end
end
