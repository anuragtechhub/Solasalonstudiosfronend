class AddEmailAddressForReportsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :email_address_for_reports, :string
  end
end
