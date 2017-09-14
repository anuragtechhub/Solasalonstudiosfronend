class AddLocationToStudios < ActiveRecord::Migration
  def change
    add_reference :studios, :location, index: true unless ActiveRecord::Base.connection.column_exists?(:studios, :location_id)
  end
end
