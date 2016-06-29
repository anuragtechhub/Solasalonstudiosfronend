namespace :locations do

  task :hyphenate => :environment do
    Location.all.each do |location|
      p "url before=#{location.url_name}, #{location.fix_url_name}"
      location.update_columns({:url_name => location.fix_url_name})
    end
  end

end