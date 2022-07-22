class AddFirstLastMiddleNameToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :first_name, :string
    add_column :stylists, :middle_name, :string
    add_column :stylists, :last_name, :string
  end
end
