class AddMoveInSpecialAndOpenHouseToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :move_in_special, :text
    add_column :locations, :open_house, :text
  end
end
