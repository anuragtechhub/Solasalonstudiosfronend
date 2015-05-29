class AddStylistServices < ActiveRecord::Migration
  def change
    add_column :stylists, :laser_hair_removal, :boolean
    add_column :stylists, :threading, :boolean
    add_column :stylists, :permanent_makeup, :boolean
  end
end
