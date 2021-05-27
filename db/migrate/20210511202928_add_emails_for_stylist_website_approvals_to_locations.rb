class AddEmailsForStylistWebsiteApprovalsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :emails_for_stylist_website_approvals, :string
  end
end
