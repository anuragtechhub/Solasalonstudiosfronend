namespace :dedupe do

	# rake dedupe:stylists_not_in_cms['Canada']
  # rake dedupe:stylists_not_in_cms['United States']
  task :stylists_not_in_cms, [:country] => :environment do |task, args|
  	p "Begin stylists_not_in_cms..."
  	stylists_in_cms = Stylist.all.map{ |s| {id: s.id, :name => s.name, email_address: s.email_address, :country => s.country} }
  	p "stylists_in_cms=#{stylists_in_cms.inspect}"

		save_path = Rails.root.join('csv',"hubspot_stylists_not_in_sola_cms_#{args.country.downcase.gsub(/ /, '_')}.csv")
    CSV.open(save_path, "wb") do |csv|
      csv << ["Name", "Email", "Sola ID", "Hubspot ID"]
      
	  	idx = 0
			CSV.foreach(Rails.root.join('csv', "hubspot_stylists_#{args.country.downcase.gsub(/ /, '_')}.csv"), :headers => false) do |row|
				idx = idx + 1
				# contact_id, email, first_name, last_name, sola id, company id, name
			  #p "row #{idx}=#{row[4]}"
			  matching_stylist_in_cms = stylists_in_cms.select { |s| (s[:id].to_s == row[4]) && (s[:country] == args.country) }
			  if matching_stylist_in_cms && matching_stylist_in_cms.length > 0
			  	p "match! #{matching_stylist_in_cms.inspect}"
			  else
			  	p "NO MATCH #{matching_stylist_in_cms.inspect}"
			  	csv << [row[6], row[1], row[4], row[0]]
			  end
			end        
    end	
  end

  # rake dedupe:stylists_not_in_hubspot['Canada']
  # rake dedupe:stylists_not_in_hubspot['United States']
  task :stylists_not_in_hubspot, [:country] => :environment do |task, args|
  	p "Begin stylists_not_in_hubspot..."
  	stylists_in_cms = Stylist.all.map{ |s| {id: s.id, :name => s.name, email_address: s.email_address, :country => s.country} }
  	p "stylists_in_cms=#{stylists_in_cms.inspect}"

  	stylists_in_hubspot = []
		save_path = Rails.root.join('csv',"sola_cms_stylists_not_in_hubspot_#{args.country.downcase.gsub(/ /, '_')}.csv")
    CSV.open(save_path, "wb") do |csv|
      csv << ["Name", "Email", "Sola ID"]
      
	  	idx = 0
			CSV.foreach(Rails.root.join('csv', "hubspot_stylists_#{args.country.downcase.gsub(/ /, '_')}.csv"), :headers => false) do |row|
				idx = idx + 1
				stylists_in_hubspot << row
			end

			stylists_in_cms.each do |stylist|
				matching_stylist_in_hubspot = stylists_in_hubspot.select { |s| (stylist[:id].to_s == s[4]) && (stylist[:country] == args.country) }
			  if matching_stylist_in_hubspot && matching_stylist_in_hubspot.length > 0
			  	p "match! #{matching_stylist_in_hubspot.inspect}"
			  elsif stylist[:country] == args.country
			  	p "NO MATCH #{matching_stylist_in_hubspot.inspect}"
			  	csv << [stylist[:name], stylist[:email_address], stylist[:id]]
			  end
    	end	        
    end
  end

  task :request_tour_inquiries_not_in_cms => :environment do |task, args|

  end

  task :request_tour_inquiries_not_in_hubspot => :environment do |task, args|

  end

end