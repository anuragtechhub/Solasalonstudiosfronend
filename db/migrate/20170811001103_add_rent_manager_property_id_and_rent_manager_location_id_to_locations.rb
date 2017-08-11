class AddRentManagerPropertyIdAndRentManagerLocationIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :rent_manager_property_id, :string, :index => true
    add_column :locations, :rent_manager_location_id, :string, :index => true
  end
end
