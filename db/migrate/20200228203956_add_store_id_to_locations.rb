class AddStoreIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :store_id, :string
  end
end
