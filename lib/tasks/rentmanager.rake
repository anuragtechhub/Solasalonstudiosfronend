namespace :rentmanager do

  require 'rest-client'

  task :locations => :environment do
    require 'json'
    p "Start Rent Manager locations task..."
    usa = Carmen::Country.all.select{|c| ['US'].include?(c.code)}.first

    locations_response = RestClient::Request.execute method: :get, url: 'https://solasalon.apiservices.rentmanager.com/api/locations', user: 'solapro', password: '20FCEF93-AD4D-4C7D-9B78-BA2492098481'
    #p "locations_response=#{locations_response.inspect}"
    locations_json = JSON.parse(locations_response)
    #p "locations_json=#{locations_json.inspect}"
    locations_json.each do |location|
      p "location locationID=#{location['locationID']}, name=#{location['Name']}, friendlyName=#{location['FriendlyName']}, https://solasalon.apiservices.rentmanager.com/api/#{location['locationID']}/Properties"
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
            else
              p "not a perfect match...lets fuzzy match..."
              fuzzy_match_sola_location = Location.fuzzy_search(:address_1 => street, :city => city, :state => carmen_state.name)
              p "fuzzy_match_sola_location=#{fuzzy_match_sola_location.inspect}"
            end
          else
            p "property NO STREET || CITY || STATE || POSTAL CODE --- properyID=#{property['PropertyID']}, name=#{property['Name']}, street=#{street}, city=#{city}, state=#{state}, postalCode=#{postal_code}"
          end
        else 
          p "property NO PRIMARY ADDRESS --- properyID=#{property['PropertyID']}, name=#{property['Name']}"
        end
      end
    end
    
    p "Finish Rent Manager locations task..."
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