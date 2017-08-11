class AddRentManagerIdToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :rent_manager_id, :string, :index => true
  end
end
