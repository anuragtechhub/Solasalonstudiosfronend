class UpdatePrivateVsWebsiteFieldsOnStylists < ActiveRecord::Migration
  def change
    remove_column :stylists, :email_address_private, :string
    add_column :stylists, :website_email_address, :string

    remove_column :stylists, :cell_phone_number, :string
    add_column :stylists, :website_phone_number, :string

    remove_column :stylists, :first_name, :string
    remove_column :stylists, :last_name, :string
    add_column :stylists, :website_name, :string
  end
end
