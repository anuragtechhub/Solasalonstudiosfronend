class AddEmailAddressToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :email_address, :string
  end
end
