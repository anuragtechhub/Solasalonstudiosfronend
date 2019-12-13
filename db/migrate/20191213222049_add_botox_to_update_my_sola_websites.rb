class AddBotoxToUpdateMySolaWebsites < ActiveRecord::Migration
  def change
    add_column :update_my_sola_websites, :botox, :boolean
  end
end
