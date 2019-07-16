class AddTotalBooknowBookingsAndTotalBooknowRevenueToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :total_booknow_bookings, :integer
    add_column :stylists, :total_booknow_revenue, :string
  end
end
