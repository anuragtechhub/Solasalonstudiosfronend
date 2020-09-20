class RemoveUniqIndexFromSylists < ActiveRecord::Migration
  def change
    remove_index :stylists, :email_address
    add_index :stylists, :email_address
  end
end
