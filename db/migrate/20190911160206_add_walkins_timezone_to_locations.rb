class AddWalkinsTimezoneToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :walkins_timezone, :string
  end
end
