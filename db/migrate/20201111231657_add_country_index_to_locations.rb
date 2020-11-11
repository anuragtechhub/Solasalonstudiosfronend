class AddCountryIndexToLocations < ActiveRecord::Migration
  def change
    add_index :locations, :country
    add_index :locations, [:status, :country]
    add_index :stylists, [:location_id, :status]
    add_index :accounts, :api_key
  end
end
