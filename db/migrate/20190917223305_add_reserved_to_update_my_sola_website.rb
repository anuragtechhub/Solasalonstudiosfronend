class AddReservedToUpdateMySolaWebsite < ActiveRecord::Migration
  def change
    add_column :update_my_sola_websites, :reserved, :boolean, :default => false
  end
end
