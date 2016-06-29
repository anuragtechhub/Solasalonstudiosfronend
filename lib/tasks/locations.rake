namespace :locations do

  task :hyphenate => :environment do
    Location.all.each do |location|
      p "Location url before=#{location.url_name}, after=#{location.fix_url_name}"
      location.save
    end

    Msa.all.each do |msa|
      p "MSA url before=#{msa.url_name}, after=#{msa.fix_url_name}"
      msa.save
    end    
  end

end