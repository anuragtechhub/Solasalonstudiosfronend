namespace :locations do

  task :hyphenate => :environment do
    Location.all.each do |location|
      p "Location url before=#{location.url_name}, after=#{location.fix_url_name}"
      location.update_columns(:url_name => location.url_name)
    end

    Msa.all.each do |msa|
      p "MSA url before=#{msa.url_name}, after=#{msa.fix_url_name}"
      msa.update_columns(:url_name => msa.url_name)
    end    
  end

end