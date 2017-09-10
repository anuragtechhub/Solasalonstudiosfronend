class AddLocationToStudios < ActiveRecord::Migration
  def change
    add_reference :studios, :location, index: true
  end
end
