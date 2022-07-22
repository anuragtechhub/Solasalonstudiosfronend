class AddcolumnsToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :billing_first_name, :string
    add_column :stylists, :billing_last_name, :string
    add_column :stylists, :billing_email, :string
    add_column :stylists, :billing_phone, :string
  end
end
