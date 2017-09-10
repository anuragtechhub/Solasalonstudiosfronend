namespace :rentmanager do

  require 'rest-client'

  task :locations => :environment do
    require 'json'
    p "Start Rent Manager locations task..."

    matched_properties = []
    unmatched_properties = []

    usa = Carmen::Country.all.select{|c| ['US'].include?(c.code)}.first
    CSV.open(Rails.root.join('csv','rent_manager_locations.csv'), "wb") do |csv|

      csv << ['RM Location ID', 'RM Property ID', 'RM Name', 'RM Address', 'RM City', 'RM State', 'Sola ID', 'Sola Name', 'Sola Address', 'Sola City', 'Sola State', 'Matched?', 'Notes']

      locations_response = RestClient::Request.execute method: :get, url: 'https://solasalon.apiservices.rentmanager.com/api/locations', user: 'solapro', password: '20FCEF93-AD4D-4C7D-9B78-BA2492098481'
      #p "locations_response=#{locations_response.inspect}"
      locations_json = JSON.parse(locations_response)
      #p "locations_json=#{locations_json.inspect}"
      
      locations_json.each do |location|
        p "location locationID=#{location['locationID']}, name=#{location['Name']}, friendlyName=#{location['FriendlyName']}"
        properties_response = RestClient::Request.execute method: :get, url: "https://solasalon.apiservices.rentmanager.com/api/#{location['locationID']}/Properties", user: 'solapro', password: '20FCEF93-AD4D-4C7D-9B78-BA2492098481'
        #p "properties_response=#{properties_response.inspect}"
        properties_json = JSON.parse(properties_response)
        #p "properties_json=#{properties_json.inspect}"
        properties_json.each do |property|
          #p "property=#{property.inspect}"
          primary_address = property['PrimaryAddress']
          if primary_address
            street = primary_address['Street']
            city = primary_address['City']
            state = primary_address['State']
            postal_code = primary_address['PostalCode']
            carmen_state = usa.subregions.coded(state)

            if street.present? && city.present? && state.present? && carmen_state.present? #&& postal_code.present?

              p "property properyID=#{property['PropertyID']}, name=#{property['Name']}, street=#{street}, city=#{city}, carmen_state=#{carmen_state.name} state=#{state}, postalCode=#{postal_code}"
              # let's match it
              perfect_match_sola_location = Location.find_by(:address_1 => street, :city => city, :state => carmen_state.name)
              if perfect_match_sola_location
                p "PERFECT MATCH!!! #{perfect_match_sola_location.id}, #{perfect_match_sola_location.name}, #{perfect_match_sola_location.full_address}"

                perfect_match_sola_location.rent_manager_property_id = property['PropertyID']
                perfect_match_sola_location.rent_manager_location_id = location['locationID']
                perfect_match_sola_location.save

                matched_properties << perfect_match_sola_location

                csv << [location['locationID'], property['PropertyID'], property['Name'], street, city, state, perfect_match_sola_location.id, perfect_match_sola_location.name, perfect_match_sola_location.address_1, perfect_match_sola_location.city, carmen_state.code, 'Yes', 'Perfect match']
              else
                p "not a perfect match...lets fuzzy match..."
                fuzzy_match_sola_location = Location.fuzzy_search(:address_1 => street, :city => city, :state => carmen_state.name).first
                if fuzzy_match_sola_location
                  p "Fuzzy Match!  #{fuzzy_match_sola_location.id}, #{fuzzy_match_sola_location.name}, #{fuzzy_match_sola_location.full_address}"

                  fuzzy_match_sola_location.rent_manager_property_id = property['PropertyID']
                  fuzzy_match_sola_location.rent_manager_location_id = location['locationID']
                  fuzzy_match_sola_location.save

                  matched_properties << fuzzy_match_sola_location

                  csv << [location['locationID'], property['PropertyID'], property['Name'], street, city, state, fuzzy_match_sola_location.id, fuzzy_match_sola_location.name, fuzzy_match_sola_location.address_1, fuzzy_match_sola_location.city, carmen_state.code, 'Yes', 'Fuzzy match']
                else
                  p "tried to fuzzy match, but failed"

                  unmatched_properties << property

                  csv << [location['locationID'], property['PropertyID'], property['Name'], street, city, state, nil, nil, nil, nil, nil, 'No', 'Tried to match using both perfect and fuzzy match, but both matching attempts failed.']
                end
              end
            else
              p "property NO STREET || CITY || STATE --- properyID=#{property['PropertyID']}, name=#{property['Name']}, street=#{street}, city=#{city}, state=#{state}, postalCode=#{postal_code}"

              unmatched_properties << property

              csv << [location['locationID'], property['PropertyID'], property['Name'], street, city, state, nil, nil, nil, nil, nil, 'No', 'Could not be matched because property in Rent Manager was missing street address, city or state.']
            end
          else 
            p "property NO PRIMARY ADDRESS --- properyID=#{property['PropertyID']}, name=#{property['Name']}"
            
            unmatched_properties << property

            csv << [location['locationID'], property['PropertyID'], property['Name'], nil, nil, nil, nil, nil, nil, nil, nil, 'No', 'Could not be matched because property in Rent Manager did not have a primary address listed.']
          end
        end # properties_json.each
      end # locations_json.each

    end # csv.open
    
    p "Finished Rent Manager locations task. #{(matched_properties + unmatched_properties).size} total, #{matched_properties.size} matched, #{unmatched_properties.size} unmatched. "
  end

  task :properties => :environment do
    p "Start Rent Manager properties task..."

    response = RestClient::Request.execute method: :get, url: 'https://solasalon.apiservices.rentmanager.com/api/170/tenants', user: 'solapro', password: '20FCEF93-AD4D-4C7D-9B78-BA2492098481'
    p "response=#{response.inspect}"
    
    p "Finish Rent Manager properties task..."
  end

  task :tenants => :environment do
    p "Start Rent Manager tenants task..."



    p "Finish Rent Manager tenants task..."
  end

  task :studios => :environment do
    p "Start Rent Manager studios task..."



    p "Finish Rent Manager studios task..."
  end  

end
