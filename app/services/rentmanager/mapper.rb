# Sync Rent Manger IDs
# Go over all RM properties and save ids into DB

module Rentmanager
  class Mapper
    def initialize
      @client = Client.new
    end

    def sync
      @client.locations.each do |rm_location|
        rm_location_id = rm_location['LocationID']
        begin
          sync_properties(rm_location_id)
          sync_units(rm_location_id)
          sync_tenants(rm_location_id)
          sync_stylist_units(rm_location_id)
        rescue SyncError => e
          puts e.message
          next
        end
      end
    end

    class SyncError < StandardError; end

    private

    def sync_tenants(rm_location_id)
      rm_tenants = @client.tenants(rm_location_id)

      if problems?(rm_tenants)
        raise SyncError, "Tenants problems with rm_location_id = #{rm_location_id}.  #{rm_tenants}"
      end

      rm_tenants.each do |rm_tenant|
        tenant_id = rm_tenant['TenantID']
        stylists = Stylist.where(name: rm_tenant['Name'])
        if stylists.count > 1
          p "More than one stylist with name: #{rm_tenant['Name']}"
          next
        end
        stylist = stylists.first

        if stylist.blank?
          p "Can not find stylist for rm_location_id: #{rm_location_id}, TenantID: #{tenant_id}"
          next
        end

        stylist.update_column(:rm_status, rm_tenant['Status'])

        stylist.external_ids
               .rent_manager
               .find_or_initialize_by(name: :tenant_id, rm_location_id: rm_location_id).tap do |e_id|
          e_id.value = tenant_id
        end.save!
      end
    end

    def sync_stylist_units(rm_location_id)
      rm_leases = @client.leases(rm_location_id)

      if problems?(rm_leases)
        raise SyncError, "Leases problems with rm_location_id = #{rm_location_id}.  #{rm_leases}"
      end

      rm_leases.each do |rm_lease|
        next if rm_lease['UnitID'].blank?

        unit = RentManager::Unit.find_by(rm_unit_id: rm_lease['UnitID'], rm_location_id: rm_location_id)
        if unit.blank?
          p "no RentManager::Unit found for rm_unit_id = #{rm_lease['UnitID']} and rm_location_id = #{rm_location_id}"
          next
        end

        stylist = ExternalId.rent_manager.find_by(rm_location_id: rm_location_id, name: :tenant_id, value: rm_lease['TenantID'])&.stylist

        if stylist.blank?
          p "no stylist found for tenant_id = #{rm_lease['TenantID']} and rm_location_id = #{rm_location_id}"
          next
        end

        hash = {
          stylist_id: stylist.id,
          rent_manager_unit_id: unit.id,
          rm_lease_id: rm_lease['LeaseID'],
          move_in_at: (rm_lease['MoveInDate'].present? ? Time.parse(rm_lease['MoveInDate']) : nil),
          move_out_at: (rm_lease['MoveOutDate'].present? ? Time.parse(rm_lease['MoveOutDate']) : nil),
        }

        RentManager::StylistUnit.create_with(hash).
          find_or_create_by!(stylist_id: hash[:stylist_id], rent_manager_unit_id: hash[:rent_manager_unit_id]).
          update(hash)
      end
    end

    def sync_properties(rm_location_id)
      rm_properties = @client.properties(rm_location_id)

      if problems?(rm_properties)
        raise SyncError, "Properties problems with rm_location_id = #{rm_location_id}.  #{rm_properties}"
      end

      rm_properties.each do |rm_property|
        store_id = user_value(rm_property, 'Sola ID')
        next if store_id.blank?

        location = Location.find_by(store_id: store_id)
        if location.blank?
          p "Can not find location for rm_location_id: #{rm_location_id}, store_id: #{store_id}"
          next
        end

        location.external_ids
                .rent_manager
                .find_or_initialize_by(name: :property_id, rm_location_id: rm_location_id).tap do |e_id|
          e_id.value = rm_property['PropertyID']
        end.save!
      end
    end

    def sync_units(rm_location_id)
      rm_units = @client.units(rm_location_id)

      if problems?(rm_units)
        raise SyncError, "Units problems with rm_location_id = #{rm_location_id}. #{rm_units}"
      end

      rm_units.each do |rm_unit|
        property_id = rm_unit['PropertyID']
        location = ExternalId.find_location_by(rm_location_id, property_id)

        if location.blank?
          p "Can not find location for rm_location_id: #{rm_location_id}, PropertyID: #{property_id}"
          next
        end

        hash = {
          name: rm_unit['Name'],
          comment: rm_unit['Comment'],
          location_id: location.id,
          rm_property_id: property_id,
          rm_unit_type_id: rm_unit['UnitTypeID']
        }

        location.rent_manager_units
                .create_with(hash)
                .find_or_create_by!(rm_unit_id: rm_unit['UnitID'], rm_location_id: rm_location_id)
                .update!(hash)
      end
    end

    def problems?(obj)
      obj.nil? || obj.is_a?(Hash) && obj[:error]
    end

    def user_value(obj, name)
      value = obj['UserDefinedValues'].find { |data| data.try('[]', 'Name').to_s == name }.try('[]', 'Value')
      value.to_s.strip if value.present?
    end
  end
end
