class AddRockbotManagerEmailToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :rockbot_manager_email, :string
    execute("UPDATE locations SET rockbot_manager_email = email_address_for_inquiries;")
  end
end
