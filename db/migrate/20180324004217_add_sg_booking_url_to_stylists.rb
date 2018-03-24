class AddSgBookingUrlToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :sg_booking_url, :string
  end
end
