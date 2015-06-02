class RenameWebsiteToWebsiteUrl < ActiveRecord::Migration
  def change
    rename_column :stylists, :website, :website_url
  end
end
