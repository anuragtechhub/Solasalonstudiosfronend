class AddSgBookingUrlToStylists < ActiveRecord::Migration
  def change
  	unless ActiveRecord::Base.connection.column_exists?(:stylists, :sg_booking_url)
    	add_column :stylists, :sg_booking_url, :string
  	end
  end
end
