class AddPrivateContactInformationToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :first_name, :string
    add_column :stylists, :last_name, :string
    add_column :stylists, :date_of_birth, :date
    add_column :stylists, :street_address, :string
    add_column :stylists, :city, :string
    add_column :stylists, :state, :string
    add_column :stylists, :postal_code, :string
    add_column :stylists, :cell_phone_number, :string
    add_column :stylists, :email_address_private, :string
    add_column :stylists, :emergency_contact_name, :string
    add_column :stylists, :emergency_contact_relationship, :string
    add_column :stylists, :emergency_contact_phone_number, :string
  end
end
