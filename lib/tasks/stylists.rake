namespace :stylist do

  task :hyphenate => :environment do
    Stylist.all.each do |stylist|
      p "stylist url before=#{stylist.url_name}, after=#{stylist.fix_url_name}"
      stylist.update_columns(:url_name => stylist.url_name)
    end  
  end

  task :sg_booking_url => :environment do
  	Stylist.all.each do |stylist|
  		if stylist.booking_url.present? && stylist.booking_url.include?('glossgenius.com')
  			p "SOLAGENIUS!!!! #{stylist.url_name}, #{stylist.booking_url}"
  			stylist.sg_booking_url = stylist.booking_url
  			stylist.booking_url = nil
  			#p "INSPECT #{stylist.sg_booking_url}, #{stylist.booking_url}"
  			stylist.save(:validate => false)
  		else
  			p "No SolaGenius #{stylist.email_address}, #{stylist.booking_url}"
  		end
  	end
  end

end