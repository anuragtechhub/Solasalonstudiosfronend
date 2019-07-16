class CreateBookNowBookings < ActiveRecord::Migration
  def change
    create_table :book_now_bookings do |t|
      t.string :time_range
      t.references :location, index: true
      t.string :query
      t.json :services
      t.references :stylist, index: true
      t.string :booking_user_name
      t.string :booking_user_phone
      t.string :booking_user_email
      t.string :referring_url
      t.string :total

      t.timestamps
    end
  end
end
