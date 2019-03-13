jan_1 = Date.new(2019, 1, 1)
today = Date.today
rtis = RequestTourInquiry.where(:created_at => (jan_1..today))

p "Name, Email, Phone, Message, URL, Created At, Location Name"
rtis.each do |rti|
	if rti.location
		p "#{rti.name}, #{rti.email}, #{rti.phone}, #{rti.message}, #{rti.request_url}, #{rti.created_at}, #{rti.location.name}"
	end
end