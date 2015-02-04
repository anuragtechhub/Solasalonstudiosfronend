class AddLegacyIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :legacy_id, :string
  end
end
