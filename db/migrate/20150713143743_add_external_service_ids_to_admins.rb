class AddExternalServiceIdsToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :mailchimp_api_key, :string
    add_column :admins, :callfire_app_login, :string
    add_column :admins, :callfire_app_password, :string
  end
end
