# frozen_string_literal: true

namespace :moz do
  # retrieves all submissions

  task businesses: :environment do
    moz_token = Moz.first.token
    moz_response = `curl -X GET \
      https://localapp.moz.com/api/businesses \
      -H 'accessToken: #{moz_token}' \
      -H 'Content-Type: application/json'`
    # p "moz_response=#{moz_response}"
    json_response = JSON.parse(moz_response)
    # p "businesses=#{json_response["response"]["businesses"]}"
    json_response['response']['businesses'].each do |business|
      p "business=#{business}"
    end
  end

  task set_location_ids: :environment do
    moz_token = Moz.first.token
    moz_response = `curl -X GET \
      https://localapp.moz.com/api/locations?max=1000 \
      -H 'accessToken: #{moz_token}' \
      -H 'Content-Type: application/json'`
    # p "moz_response=#{moz_response}"
    json_response = JSON.parse(moz_response)
    locations = json_response['response']['locations']
    p "locations.size=#{locations.size}"
    non_match_count = 0
    match_count = 1
    locations.each do |location|
      # p "location=#{location}"
      sola_location = Location.where('address_1 LIKE ? AND TRIM(postal_code) = ?', "%#{location['streetNo']}%", location['zip']) # Location.fuzzy_search(:address_1 => location["streetAndNumber"], :postal_code => location["zip"]) ||

      if sola_location&.size&.positive?
        sola_location = sola_location.first
        if sola_location.moz_id.present?
          # p "matched location, but already has moz_id #{location["streetAndNumber"]}, #{location["streetNo"]}, #{location["zip"]}"
        else
          p "matching sola_location! #{location['streetAndNumber']} | #{sola_location.address_1} --- #{sola_location.id}, setting moz_id=#{location['id']}"
          match_count += 1
          sola_location.moz_id = location['id']
          sola_location.save
          # moz_id = location["id"]
        end
      else
        p "DID NOT MATCH #{location['streetAndNumber']}, #{location['streetNo']}, #{location['zip']}|"
        non_match_count += 1
      end
    end

    p "match_count=#{match_count}"
    p "non_match_count=#{non_match_count}"
    # p "businesses=#{json_response["response"]["businesses"]}"
    # json_response["response"]["businesses"].each do |business|
    #   p "business=#{business}"
    # end
  end

  task sync_locations: :environment do
    p 'begin moz:sync_locations...'
    locations = Location.open
    p "locations.size=#{locations.size}"
    locations.each_with_index do |location, idx|
      p "##{idx} location id=#{location.id}, name=#{location.name}"
      location.submit_to_moz
    end
    p 'end moz:sync_locations'
  end

  # def addressFromMozLocation(location=nil)
  #   return nil unless location
  #   if location["addressExtra"] && location["addressExtra"].present?
  #     return "#{location["streetAndNumber"]}, #{location["addressExtra"]}"
  #   else
  #     return location["streetAndNumber"]
  #   end
  # end
end
