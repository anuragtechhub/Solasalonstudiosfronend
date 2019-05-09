class AddReservedToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :reserved, :boolean, :default => false
  end
end
