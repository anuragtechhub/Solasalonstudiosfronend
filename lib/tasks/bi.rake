namespace :bi do

  task :stylists_with_non_hair_services => :environment do
    p "Begin stylists_with_non_hair_services..."
    CSV.open(Rails.root.join('csv','stylists_with_non_hair_services.csv'), "wb") do |csv|
      csv << ['Name', 'Email Address', 'Phone Number', 'Location Name', 'Location City', 'Skin', 'Nails', 'Massage', 'Microblading', 'Makeup', 'Waxing', 'Brows']
      Stylist.where(:status => 'open').each do |stylist|
        next unless stylist.location && stylist.location.name
        p "adding stylist #{stylist.name}, #{stylist.email_address}"

        csv << [stylist.name, stylist.email_address, stylist.phone_number, stylist.location.name, stylist.location.city, stylist.skin, stylist.nails, stylist.massage, stylist.microblading, stylist.makeup, stylist.waxing, stylist.brows]
      end
    end
    p "End stylists_with_non_hair_services"
  end

  task :all_stylists => :environment do
    CSV.open(Rails.root.join('csv','all_stylists.csv'), "wb") do |csv|
      Location.where(:status => 'open').each do |location|
        p "location=#{location.name}, #{location.city}, #{location.state}"
        location.stylists.each do |stylist|
          csv << [location.name, stylist.name, stylist.phone_number, stylist.email_address]
        end
      end
    end
  end

  task :stylists_in_california => :environment do
    CSV.open(Rails.root.join('csv','stylists_in_california.csv'), "wb") do |csv|
      Location.where(:status => 'open').where('lower(state) = ?', 'california').where(:country => 'US').each do |location|
        p "location=#{location.name}, #{location.city}, #{location.state}"
        location.stylists.each do |stylist|
          csv << [location.name, stylist.name, stylist.phone_number, stylist.email_address]
        end
      end
    end
  end

end