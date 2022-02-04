class AddRmLocationIdToExternalIds < ActiveRecord::Migration
  def change
    add_column :external_ids, :rm_location_id, :bigint
  end
end
