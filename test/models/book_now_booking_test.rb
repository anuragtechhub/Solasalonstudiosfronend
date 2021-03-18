require 'test_helper'

class BookNowBookingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: book_now_bookings
#
#  id                 :integer          not null, primary key
#  booking_user_email :string(255)
#  booking_user_name  :string(255)
#  booking_user_phone :string(255)
#  query              :string(255)
#  referring_url      :string(255)
#  services           :json
#  time_range         :string(255)
#  total              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  location_id        :integer
#  stylist_id         :integer
#
# Indexes
#
#  index_book_now_bookings_on_location_id  (location_id)
#  index_book_now_bookings_on_stylist_id   (stylist_id)
#
