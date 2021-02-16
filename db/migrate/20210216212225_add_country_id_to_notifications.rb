class AddCountryIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :country_id, :integer
    add_index :notifications, :country_id
  end
end
