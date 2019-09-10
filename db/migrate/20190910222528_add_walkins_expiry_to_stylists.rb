class AddWalkinsExpiryToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :walkins_expiry, :datetime, :default => nil
  end
end
