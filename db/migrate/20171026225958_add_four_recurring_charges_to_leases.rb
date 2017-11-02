class AddFourRecurringChargesToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :recurring_charge_1_id, :integer unless ActiveRecord::Base.connection.column_exists?(:leases, :recurring_charge_1_id)
    add_column :leases, :recurring_charge_2_id, :integer unless ActiveRecord::Base.connection.column_exists?(:leases, :recurring_charge_2_id)
    add_column :leases, :recurring_charge_3_id, :integer unless ActiveRecord::Base.connection.column_exists?(:leases, :recurring_charge_3_id)
    add_column :leases, :recurring_charge_4_id, :integer unless ActiveRecord::Base.connection.column_exists?(:leases, :recurring_charge_4_id)

    add_index :leases, :recurring_charge_1_id unless ActiveRecord::Base.connection.index_exists?(:leases, :recurring_charge_1_id)
    add_index :leases, :recurring_charge_2_id unless ActiveRecord::Base.connection.index_exists?(:leases, :recurring_charge_2_id)
    add_index :leases, :recurring_charge_3_id unless ActiveRecord::Base.connection.index_exists?(:leases, :recurring_charge_3_id)
    add_index :leases, :recurring_charge_4_id unless ActiveRecord::Base.connection.index_exists?(:leases, :recurring_charge_4_id)
  end
end
