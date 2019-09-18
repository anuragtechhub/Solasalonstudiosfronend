class AddWalkinsEnabledMaxWalkinsTimeAndWalkinsEndOfDayToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :walkins_enabled, :boolean, :default => false
    add_column :locations, :max_walkins_time, :integer, :default => 60
    add_column :locations, :walkins_end_of_day, :time
  end
end
