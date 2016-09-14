class AddPublishedToUpdateMySolaWebsite < ActiveRecord::Migration
  def change
    add_column :update_my_sola_websites, :published, :boolean, :default => false
  end
end
