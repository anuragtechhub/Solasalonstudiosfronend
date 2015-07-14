class AddCustomMapsUrlToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :custom_maps_url, :text
  end
end
