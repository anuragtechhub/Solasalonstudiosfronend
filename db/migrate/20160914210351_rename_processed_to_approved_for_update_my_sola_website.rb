class RenameProcessedToApprovedForUpdateMySolaWebsite < ActiveRecord::Migration
  def change
    rename_column :update_my_sola_websites, :published, :approved
  end
end
