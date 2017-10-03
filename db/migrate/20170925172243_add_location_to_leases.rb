class AddLocationToLeases < ActiveRecord::Migration
  def change
    add_reference :leases, :location, index: true unless ActiveRecord::Base.connection.column_exists?(:leases, :location_id)
  end
end
