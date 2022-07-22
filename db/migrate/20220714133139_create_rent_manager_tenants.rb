class CreateRentManagerTenants < ActiveRecord::Migration
  def change
    create_table :rent_manager_tenants do |t|
      t.integer :tenant_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.integer :location_id
      t.integer :property_id
      t.string :email
      t.string :phone
      t.string :status
      t.datetime :active_start_date
      t.datetime :active_end_date
      t.datetime :last_transaction_date
      t.datetime :last_payment_date
      t.datetime :move_in_at
      t.datetime :move_out_at

      t.timestamps null: false
    end
  end
end
