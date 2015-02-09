class AddLocationNameToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :location_name, :string
  end
end
