class AddWalkinsToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :walkins, :boolean
  end
end
