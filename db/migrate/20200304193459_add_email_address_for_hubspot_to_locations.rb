class AddEmailAddressForHubspotToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :email_address_for_hubspot, :string
  end
end
