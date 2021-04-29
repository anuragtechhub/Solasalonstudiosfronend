class BookNowBooking < ActiveRecord::Base

  belongs_to :location
  belongs_to :stylist

	after_commit :update_stylist_metrics, on: :create
	after_commit :sync_with_hubspot, on: :create

  def services_booked
  	s = []

  	self.services.each do |service|
  		s << service[1]["name"]
  	end

  	s.to_sentence
  end

  def sync_with_hubspot
		::Hubspot::BookNowJob.perform_async(self.id)
  end

  def update_stylist_metrics
  	stylist = self.stylist
  	if stylist
  		total_revenue = 0.0
  		BookNowBooking.where(:stylist_id => stylist.id).each do |b|
  			b_total = b.total
  			if b_total.start_with? '$'
  				b_total[0] = ''
  			end
  			total_revenue = total_revenue + b_total.to_f
  		end
  		stylist.total_booknow_revenue = "$#{total_revenue.to_i}+"
  		stylist.total_booknow_bookings = BookNowBooking.where(:stylist_id => stylist.id).size
  		stylist.save
  	end
  rescue => e
		NewRelic::Agent.notice_error(e)
		Rollbar.error(e)
  end

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
