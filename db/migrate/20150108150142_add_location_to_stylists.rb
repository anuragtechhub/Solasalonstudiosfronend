class AddLocationToStylists < ActiveRecord::Migration
  def change
    add_reference :stylists, :location, index: true
  end
end
