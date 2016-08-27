class AddCountryToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :country, :string, :default => 'US'
  end
end