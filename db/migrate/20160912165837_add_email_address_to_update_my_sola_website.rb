class AddEmailAddressToUpdateMySolaWebsite < ActiveRecord::Migration
  def change
    add_column :update_my_sola_websites, :email_address, :string
  end
end
