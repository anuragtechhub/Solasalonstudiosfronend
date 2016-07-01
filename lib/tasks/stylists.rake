namespace :stylist do

  task :hyphenate => :environment do
    Stylist.all.each do |stylist|
      p "stylist url before=#{stylist.url_name}, after=#{stylist.fix_url_name}"
      stylist.update_columns(:url_name => stylist.url_name)
    end  
  end

end