class AddRentManagerEnabledToLocations < ActiveRecord::Migration
  def change
  	unless ActiveRecord::Base.connection.column_exists?('locations', 'rent_manager_enabled')
    	add_column :locations, :rent_manager_enabled, :boolean, :default => false
    end
  end
end
