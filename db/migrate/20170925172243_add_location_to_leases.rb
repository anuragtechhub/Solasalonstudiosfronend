class AddLocationToLeases < ActiveRecord::Migration
  def change
    add_reference :leases, :location, index: true
  end
end
