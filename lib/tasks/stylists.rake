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

  task :turn_off_walkins => :environment do
    #now = DateTime.now 
    # AND walkins_expiry <= ?', true, now
    Stylist.where('walkins = ? AND walkins_expiry IS NOT NULL', true).each do |stylist|
      begin
        now = DateTime.now.change(:offset => stylist.location.walkins_offset)#.in_time_zone(stylist.location.walkins_timezone_offset)
        walkins_expiry = stylist.walkins_expiry.change(:offset => stylist.location.walkins_offset)#.in_time_zone(stylist.location.walkins_timezone_offset)
        p "now=#{now}, walkins_expiry=#{walkins_expiry}"
        if walkins_expiry <= now
          p "gotta turn off walkins for #{stylist.id}, #{stylist.email_address}"
          stylist.walkins = false
          stylist.walkins_expiry = nil
          if stylist.save
            p "walkins settings for stylist updated successfully!"
          else
            p "walkins settings for stylist NOT updated successfully: #{stylist.errors.inspect}"
          end
        end
      rescue => e 
        p "error updating walkins settings for stylist #{stylist.id}, #{e}"
      end
    end
  end

  task :sync_with_hubspot => :environment do 
    Stylist.open.each do |stylist|
      p "sync stylist #{stylist.id}, #{stylist.email_address}, #{stylist.location.name if stylist.location}"
      stylist.sync_with_hubspot
    end
  end

end