class AddExternalServiceIdsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :mailchimp_list_ids, :text
    add_column :locations, :callfire_list_ids, :text
  end
end
