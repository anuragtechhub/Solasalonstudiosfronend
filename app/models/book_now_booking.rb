class BookNowBooking < ActiveRecord::Base
  
  belongs_to :location
  belongs_to :stylist

  after_create :sync_with_hubspot, :update_stylist_metrics

  def services_booked
  	s = []
  	
  	self.services.each do |service|
  		s << service[1]["name"]
  	end

  	s.to_sentence
  end
 
  def sync_with_hubspot
    p "sync_with_hubspot!"

    if ENV['HUBSPOT_API_KEY'].present?
      p "HUBSPOT API KEY IS PRESENT, lets sync.."

      Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'], portal_id: ENV['HUBSPOT_PORTAL_ID'])

      Hubspot::Form.find("49552c63-f86b-4207-bb27-df3b568da6fa").submit({
        email: self.stylist.email_address,
        location_name: self.location.present? ? self.location.name : '',
        location_id: self.location_id || '',
        time_range: self.time_range,
        services_booked: self.services_booked,
        query: self.query,
      	booking_user_name: self.booking_user_name,
      	booking_user_phone: self.booking_user_phone,
      	booking_user_email: self.booking_user_email,
      	referring_url: self.referring_url,
      	total: self.total
      })
    else
      p "No HUBSPOT API KEY, no sync"
    end
  rescue => e
    # shh...
    p "error sync_with_hubspot #{e}"
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
  	# shh...
  	p "error with update_stylist_metrics #{e}"
  end

end