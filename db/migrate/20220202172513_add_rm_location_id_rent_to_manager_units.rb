class AddRmLocationIdRentToManagerUnits < ActiveRecord::Migration
  def change
    add_column :rent_manager_units, :rm_location_id, :bigint
    add_index :rent_manager_units, :rm_location_id
    add_index :external_ids, :rm_location_id
    add_index :rent_manager_stylist_units, :rm_lease_id
    add_index :rent_manager_units, :rm_property_id
    add_index :rent_manager_units, :rm_unit_id
  end
end
