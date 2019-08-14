class AddMozIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :moz_id, :integer
  end
end
