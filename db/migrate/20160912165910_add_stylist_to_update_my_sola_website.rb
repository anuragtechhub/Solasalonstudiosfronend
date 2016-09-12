class AddStylistToUpdateMySolaWebsite < ActiveRecord::Migration
  def change
    add_reference :update_my_sola_websites, :stylist, index: true
  end
end
