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
    
    p "Finished Rent Manager locations task. #{(matched_properties + unmatched_properties).size} total, #{matched_properties.size} matched, #{unmatched_properties.size} unmatched."
  end

  task :tenants => :environment do
    p "Start Rent Manager tenants task..."

    matched_tenants = []
    unmatched_tenants = []

    locations = Location.where('rent_manager_location_id IS NOT NULL AND rent_manager_property_id IS NOT NULL')

    p "#{locations.size} to process"

    CSV.open(Rails.root.join('csv','rent_manager_tenants.csv'), "wb") do |csv|

      csv << ['RM Location ID', 'RM First Name', 'RM Last Name', 'RM Email', 'Sola ID', 'Sola Name', 'Sola Email', 'Sola Location Name', 'Matched?', 'Notes']

      locations.each do |location|
        p "Process tenants for location #{location.name}"
        p "https://solasalon.apiservices.rentmanager.com/api/#{location.rent_manager_location_id}/Tenants?propertyid=#{location.rent_manager_property_id}"
        tenants_response = RestClient::Request.execute method: :get, url: "https://solasalon.apiservices.rentmanager.com/api/#{location.rent_manager_location_id}/Tenants?propertyid=#{location.rent_manager_property_id}", user: 'solapro', password: '20FCEF93-AD4D-4C7D-9B78-BA2492098481'
        #p "tenants_response=#{tenants_response.inspect}"
        tenants_json = JSON.parse(tenants_response)
        p "#{tenants_json.length} tenants to process for #{location.name}"
        tenants_json.each do |tenant|
          p "looking up tenant #{tenant['TenantID']}, #{tenant['FirstName']}, #{tenant['LastName']}"
          primary_contact = tenant['PrimaryContact']

          if primary_contact
            p "we have primary contact info, lets try to match with that"
            perfect_match_sola_stylist = Stylist.find_by(:location_id => location.id, :email_address => primary_contact['Email']) || Stylist.find_by(:location_id => location.id, :name => "#{primary_contact['FirstName']} #{primary_contact['LastName']}")
            if perfect_match_sola_stylist
              perfect_match_sola_stylist.rent_manager_id = tenant['TenantID']
              perfect_match_sola_stylist.save

              matched_tenants << perfect_match_sola_stylist
              csv << [location.rent_manager_location_id, primary_contact['FirstName'], primary_contact['LastName'], primary_contact['Email'], perfect_match_sola_stylist.id, perfect_match_sola_stylist.name, perfect_match_sola_stylist.email_address, location.name, 'Yes', 'Perfect match']
              p "PERFECT MATCH on primary contact name or email!!! RM tenant_id #{primary_contact['FirstName']} #{primary_contact['LastName']} matches Sola stylist_id #{perfect_match_sola_stylist.id} - #{perfect_match_sola_stylist.name}"
              next
            else
              # try fuzzy match
              fuzzy_match_sola_stylist = Stylist.fuzzy_search(:name => "#{primary_contact['FirstName']} #{primary_contact['LastName']}", :email_address => primary_contact['Email']).where(:location_id => location.id).first
              if fuzzy_match_sola_stylist
                fuzzy_match_sola_stylist.rent_manager_id = tenant['TenantID']
                fuzzy_match_sola_stylist.save

                matched_tenants << fuzzy_match_sola_stylist
                csv << [location.rent_manager_location_id, primary_contact['FirstName'], primary_contact['LastName'], primary_contact['Email'], fuzzy_match_sola_stylist.id, fuzzy_match_sola_stylist.name, fuzzy_match_sola_stylist.email_address, location.name, 'Yes', 'Fuzzy match']
                p "Fuzzy Match on primary contact name or email!!! RM tenant_id #{primary_contact['FirstName']} #{primary_contact['LastName']} matches Sola stylist_id #{fuzzy_match_sola_stylist.id} - #{fuzzy_match_sola_stylist.name}"
                next
              else
                # if we're here...nothing has matched
                p "no match on primary_contact...continue on..."
              end
            end
          end

          p "NOTHING HAS MATCHED YET...lets try matching off basic first and last"

          perfect_match_sola_stylist = Stylist.find_by(:location_id => location.id, :name => "#{tenant['FirstName']} #{tenant['LastName']}")
          if perfect_match_sola_stylist
            perfect_match_sola_stylist.rent_manager_id = tenant['TenantID']
            perfect_match_sola_stylist.save

            matched_tenants << perfect_match_sola_stylist
            csv << [location.rent_manager_location_id, tenant['FirstName'], tenant['LastName'], nil, perfect_match_sola_stylist.id, perfect_match_sola_stylist.name, perfect_match_sola_stylist.email_address, location.name, 'Yes', 'Perfect match']
            p "PERFECT MATCH on name!!! RM tenant_id #{tenant['FirstName']} #{tenant['LastName']} matches Sola stylist_id #{perfect_match_sola_stylist.id} - #{perfect_match_sola_stylist.name}"
          else
            # try fuzzy match
            fuzzy_match_sola_stylist = Stylist.fuzzy_search(:name => "#{tenant['FirstName']} #{tenant['LastName']}").where(:location_id => location.id).first
            if fuzzy_match_sola_stylist
              fuzzy_match_sola_stylist.rent_manager_id = tenant['TenantID']
              fuzzy_match_sola_stylist.save

              matched_tenants << fuzzy_match_sola_stylist
              csv << [location.rent_manager_location_id, tenant['FirstName'], tenant['LastName'], nil, fuzzy_match_sola_stylist.id, fuzzy_match_sola_stylist.name, fuzzy_match_sola_stylist.email_address, location.name, 'Yes', 'Fuzzy match']
              p "Fuzzy Match on name!!! RM tenant_id #{tenant['FirstName']} #{tenant['LastName']} matches Sola stylist_id #{fuzzy_match_sola_stylist.id} - #{fuzzy_match_sola_stylist.name}"
            else
              p "no match :("
              csv << [location.rent_manager_location_id, tenant['FirstName'], tenant['LastName'], nil, nil, nil, nil, location.name, 'No', 'Could not be matched by FirstName, LastName or Email']

              unmatched_tenants << tenant
            end
          end

          #p "tenant=#{tenant.inspect}"
        end
      end

    end # csv.open

    p "Finish Rent Manager tenants task. #{(matched_tenants + unmatched_tenants).size} total, #{matched_tenants.size} matched, #{unmatched_tenants.size} unmatched."
  end

  task :studios => :environment do
    p "Start Rent Manager studios task..."

    locations = Location.where('rent_manager_location_id IS NOT NULL AND rent_manager_property_id IS NOT NULL')
    studios_created = 0

    p "#{locations.size} to process"

    locations.each do |location|
      p "Process units for location #{location.name}"

      studios_updated = []
      p "https://solasalon.apiservices.rentmanager.com/api/#{location.rent_manager_location_id}/Units?propertyid=#{location.rent_manager_property_id}"
      units_response = RestClient::Request.execute method: :get, url: "https://solasalon.apiservices.rentmanager.com/api/#{location.rent_manager_location_id}/Units?propertyid=#{location.rent_manager_property_id}", user: 'solapro', password: '20FCEF93-AD4D-4C7D-9B78-BA2492098481'
      #p "units_response=#{units_response.inspect}"
      units_json = JSON.parse(units_response)   
      p "#{units_json.length} units to process for #{location.name}"   
      
      units_json.each do |unit|
        #p "unit=#{unit.inspect}"
        sola_unit = Studio.find_or_create_by(:rent_manager_id => unit['UnitID'].to_s, :location_id => location.id)
        sola_unit.name = unit['Name']
        studios_updated << sola_unit
        studios_created = studios_created + 1
      end

      p "studios_updated=#{studios_updated.size}"
      studios_to_delete = Studio.where('location_id = ? AND id NOT IN (?)', location.id, studios_updated.map{|s| s.id})
      p "found #{studios_to_delete.size} studios to delete"
    end

    p "Finish Rent Manager studios task. #{locations.size} locations. #{studios_created} studios imported/created"
  end  

end
