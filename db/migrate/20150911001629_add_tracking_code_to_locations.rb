class AddTrackingCodeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :tracking_code, :text
  end
end
