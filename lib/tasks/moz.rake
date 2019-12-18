namespace :moz do

  # retrieves all submissions
  task :submissions => :environment do
    require 'net/https'
    require 'json'

    http = Net::HTTP.new('moz.com', 443)
    http.use_ssl = true

    http.start do |http|
      req = Net::HTTP::Get.new("/local/api/v1/submissions?access_token=JdoGE2CnK7Uj_w9hfkgQduHuKGWLsyGb")
      #req.set_form_data({'access_token' => 'JdoGE2CnK7Uj_w9hfkgQduHuKGWLsyGb'})
      resp = http.request(req)

      JSON.parse(resp.body).each do |entry|
        p "entry=#{entry.inspect}"
      end
    end
  end

  task :businesses => :environment do
    moz_token = Moz.first.token
    moz_response = `curl -X GET \
      https://localapp.moz.com/api/businesses \
      -H 'accessToken: #{moz_token}' \
      -H 'Content-Type: application/json'` 
    #p "moz_response=#{moz_response}"  
    json_response = JSON.parse(moz_response)
    #p "businesses=#{json_response["response"]["businesses"]}"
    json_response["response"]["businesses"].each do |business|
      p "business=#{business}"
    end
  end

  task :location_ids => :environment do

  end

  task :sync_locations => :environment do
    p "begin moz:sync_locations..."
    locations = Location.open
    p "locations.size=#{locations.size}"
    locations.each_with_index do |location, idx|
      p "##{idx} location id=#{location.id}, name=#{location.name}"
      location.submit_to_moz
    end
    p "end moz:sync_locations"
  end

end