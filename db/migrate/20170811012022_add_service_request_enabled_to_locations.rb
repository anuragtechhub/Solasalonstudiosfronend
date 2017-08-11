class AddServiceRequestEnabledToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :service_request_enabled, :boolean, :default => false
  end
end
