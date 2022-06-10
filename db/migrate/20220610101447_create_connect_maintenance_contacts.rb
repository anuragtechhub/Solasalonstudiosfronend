class CreateConnectMaintenanceContacts < ActiveRecord::Migration
  def change
    create_table :connect_maintenance_contacts do |t|
      t.references :location, index: true, foreign_key: true
      t.string :contact_type
      t.integer :contact_order
      t.string :contact_first_name
      t.string :contact_last_name
      t.string :contact_phone_number
      t.string :contact_email
      t.string :contact_admin
      t.integer :contact_preference

      t.timestamps null: false
    end
  end
end
