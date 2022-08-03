# frozen_string_literal: true

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
          fetch_best_match_stylists
        rescue SyncError => e
          Rails.logger.debug e.message
          next
        end
      end
    end

    class SyncError < StandardError; end

    private

      def sync_tenants(rm_location_id)
        with_pagination do |page|
          rm_tenants = @client.tenants(rm_location_id, page)

          break if rm_tenants.blank?

          if problems?(rm_tenants)
            raise SyncError, "Tenants problems with rm_location_id = #{rm_location_id}.  #{rm_tenants}"
          end
          rm_tenants.each do |rm_tenant|
            matching_category = ''
            tenant_id = rm_tenant['TenantID']
            # TODO: refactor it
            email = rm_tenant['Contacts']&.first['Email']
            phone = rm_tenant['Contacts']&.first['PhoneNumbers']&.first
            stylists = Stylist.where(name: rm_tenant['Name'])
            if stylists.count > 1
              location_id = ExternalId.where(name: 'property_id', value: rm_tenant['PropertyID'], rm_location_id: rm_location_id).first&.objectable_id
              stylists = stylists.where(location_id: location_id) if location_id.present?
              if stylists.count > 1 && email.present? && stylists.where(email_address: email).present?
                stylists = stylists.where(email_address: email)
              end
              matching_category = 'Name'
            end
            if stylists.blank? && email.present?
              stylists = Stylist.where(email_address: email)
              stylists = check_stylists_by_email(stylists, rm_tenant, rm_location_id) if stylists.count > 1
              matching_category = 'Email'
            end

            if stylists.blank? && email.present?
              stylists = Stylist.where(billing_email: email)
              stylists = check_stylists_by_billing_email(stylists, rm_tenant, rm_location_id) if stylists.count > 1
              matching_category = 'Billing Email'
            end

            if stylists.blank? && phone.present?
              stylists = Stylist.where("NULLIF(regexp_replace(phone_number, '\D','','g'), '') = ?", phone)
              stylists = check_stylists_by_phone(stylists, rm_tenant, rm_location_id) if stylists.count > 1
              matching_category = 'Phone'
            end

            if stylists.blank? && phone.present?
              stylists = Stylist.where("NULLIF(regexp_replace(billing_phone, '\D','','g'), '') = ?", phone)
              stylists = check_stylists_by_billing_phone(stylists, rm_tenant, rm_location_id) if stylists.count > 1
              matching_category = 'Billing Phone'
            end

            if stylists.count > 1 && stylists.active.present? && rm_tenant['Status'] == 'Current'
              stylists = stylists.active
            end

            if stylists.count > 1 && stylists.inactive.present? && rm_tenant['Status'] == 'Past'
              stylists = stylists.inactive
            end

            create_rent_manager_tenant rm_tenant, rm_location_id

            next if stylists.blank?

            stylists.each do |stylist|
              stylist.update_column(:rm_status, rm_tenant['Status'])

              stylist.external_ids
                .rent_manager
                .find_or_initialize_by(name: :tenant_id, rm_location_id: rm_location_id).tap do |e_id|
                e_id.value = tenant_id
                e_id.matching_category = matching_category
                e_id.active_start_date = rm_tenant['PostingStartDate']
                e_id.active_end_date = rm_tenant['PostingEndDate']
              end.save!
            end
          end
        end
      end

      def sync_stylist_units(rm_location_id)
        with_pagination do |page|
          rm_leases = @client.leases(rm_location_id, page)

          break if rm_leases.blank?

          if problems?(rm_leases)
            raise SyncError, "Leases problems with rm_location_id = #{rm_location_id}.  #{rm_leases}"
          end

          rm_leases.each do |rm_lease|
            next if rm_lease['UnitID'].blank?

            unit = RentManager::Unit.find_by(rm_unit_id: rm_lease['UnitID'], rm_location_id: rm_location_id)
            if unit.blank?
              Rails.logger.debug { "no RentManager::Unit found for rm_unit_id = #{rm_lease['UnitID']} and rm_location_id = #{rm_location_id}" }
              next
            end

            stylist = ExternalId.rent_manager.find_by(rm_location_id: rm_location_id, name: :tenant_id, value: rm_lease['TenantID'])&.stylist

            if stylist.blank?
              Rails.logger.debug { "no stylist found for tenant_id = #{rm_lease['TenantID']} and rm_location_id = #{rm_location_id}" }
              next
            end

            hash = {
              stylist_id:           stylist.id,
              rent_manager_unit_id: unit.id,
              rm_lease_id:          rm_lease['LeaseID'],
              move_in_at:           (rm_lease['MoveInDate'].present? ? Time.zone.parse(rm_lease['MoveInDate']) : nil),
              move_out_at:          (rm_lease['MoveOutDate'].present? ? Time.zone.parse(rm_lease['MoveOutDate']) : nil)
            }

            RentManager::StylistUnit.create_with(hash)
              .find_or_create_by!(stylist_id: hash[:stylist_id], rent_manager_unit_id: hash[:rent_manager_unit_id])
              .update(hash)
          end
        end
      end

      def sync_properties(rm_location_id)
        with_pagination do |page|
          rm_properties = @client.properties(rm_location_id, page)

          break if rm_properties.blank?

          if problems?(rm_properties)
            raise SyncError, "Properties problems with rm_location_id = #{rm_location_id}.  #{rm_properties}"
          end

          rm_properties.each do |rm_property|
            store_id = user_value(rm_property, 'Sola ID')
            next if store_id.blank?

            location = Location.find_by(store_id: store_id)
            if location.blank?
              Rails.logger.debug { "Can not find location for rm_location_id: #{rm_location_id}, store_id: #{store_id}" }
              next
            end

            location.external_ids
              .rent_manager
              .find_or_initialize_by(name: :property_id, rm_location_id: rm_location_id).tap do |e_id|
              e_id.value = rm_property['PropertyID']
            end.save!
          end
        end
      end

      def sync_units(rm_location_id)
        with_pagination do |page|
          rm_units = @client.units(rm_location_id, page)

          break if rm_units.blank?

          if problems?(rm_units)
            raise SyncError, "Units problems with rm_location_id = #{rm_location_id}. #{rm_units}"
          end

          rm_units.each do |rm_unit|
            property_id = rm_unit['PropertyID']
            location = ExternalId.find_location_by(rm_location_id, property_id)

            if location.blank?
              Rails.logger.debug { "Can not find location for rm_location_id: #{rm_location_id}, PropertyID: #{property_id}" }
              next
            end

            hash = {
              name:            rm_unit['Name'],
              comment:         rm_unit['Comment'],
              location_id:     location.id,
              rm_property_id:  property_id,
              rm_unit_type_id: rm_unit['UnitTypeID']
            }

            location.rent_manager_units
              .create_with(hash)
              .find_or_create_by!(rm_unit_id: rm_unit['UnitID'], rm_location_id: rm_location_id)
              .update!(hash)
          end
        end
      end

      def fetch_best_match_stylists
        stylists = Stylist.all
        stylists.each do |stylist|
          best_tenant_id = 0
          external_ids = ExternalId.where(name: 'tenant_id', objectable_id: stylist.id, objectable_type: 'Stylist')
          external_ids.each do |e_id|
            rm_tenant = RentManagerTenant.where(tenant_id: e_id.value, location_id: e_id.rm_location_id).first
            if rm_tenant
              latest_start_date = latest_end_date = Time.at(0)
              start_date = end_date = DateTime.now
              last_status = "past"
              if last_status != "current" && rm_tenant.active_start_date.present?
                end_date = rm_tenant.active_end_date
                if (end_date.present? && end_date > latest_end_date)
                  latest_end_date = end_date
                  best_tenant_id = rm_tenant.tenant_id
                  last_status = rm_tenant.status
                elsif rm_tenant.status == 'current'
                  best_tenant_id = rm_tenant.tenant_id
                  last_status = 'current'
                end
              elsif last_status != "current" && rm_tenant.active_start_date.present?
                start_date = rm_tenant.active_start_date.present?
                if (start_date.present? && start_date > latest_start_date)
                  latest_start_date = start_date
                  best_tenant_id = rm_tenant.tenant_id
                  last_status = rm_tenant.status
                end
              elsif rm_tenant.status == 'future'
                best_tenant_id = rm_tenant.tenant_id
                last_status = 'future'
              end
            end
          end
          stylist.update(rent_manager_id: best_tenant_id) if best_tenant_id > 0
        end
      end

      def with_pagination
        page = 1
        loop do
          yield(page)
          page += 1
        end
      end

      def problems?(obj)
        obj.nil? || (obj.is_a?(Hash) && obj[:error])
      end

      def user_value(obj, name)
        value = obj['UserDefinedValues'].find { |data| data.try('[]', 'Name').to_s == name }.try('[]', 'Value')
        value.to_s.strip if value.present?
      end

      def check_stylists_by_email(stylists, rm_tenant, rm_location_id)
        if stylists.count > 1
          location_id = ExternalId.where(name: 'property_id', value: rm_tenant['PropertyID'], rm_location_id: rm_location_id).first&.objectable_id
          stylists = stylists.where(location_id: location_id) if location_id.present?
        end
        if stylists.count > 1
          stylists = stylists.where('name ilike ?', "% #{rm_tenant['LastName']}")
        end
        stylists
      end

      def check_stylists_by_phone(stylists, rm_tenant, rm_location_id)
        if stylists.count > 1
          location_id = ExternalId.where(name: 'property_id', value: rm_tenant['PropertyID'], rm_location_id: rm_location_id).first&.objectable_id
          stylists = stylists.where(location_id: location_id) if location_id.present?
        end
        if stylists.count > 1
          stylists = stylists.where('name ilike ?', "% #{rm_tenant['LastName']}")
        end
        stylists
      end

      def check_stylists_by_billing_email(stylists, rm_tenant, rm_location_id)
        if stylists.count > 1
          location_id = ExternalId.where(name: 'property_id', value: rm_tenant['PropertyID'], rm_location_id: rm_location_id).first&.objectable_id
          stylists = stylists.where(location_id: location_id) if location_id.present?
        end
        if stylists.count > 1
          stylists = stylists.where('billing_last_name ilike ?', "% #{rm_tenant['LastName']}")
        end
        stylists
      end

      def check_stylists_by_billing_phone(stylists, rm_tenant, rm_location_id)
        if stylists.count > 1
          location_id = ExternalId.where(name: 'property_id', value: rm_tenant['PropertyID'], rm_location_id: rm_location_id).first&.objectable_id
          stylists = stylists.where(location_id: location_id) if location_id.present?
        end
        if stylists.count > 1
          stylists = stylists.where('billing_last_name ilike ?', "% #{rm_tenant['LastName']}")
        end
        stylists
      end

      def create_rent_manager_tenant rm_tenant, rm_location_id
        email = rm_tenant['Contacts']&.first['Email']
        phone = rm_tenant['Contacts']&.first['PhoneNumbers'].present? ? rm_tenant['Contacts']&.first['PhoneNumbers']&.first['PhoneNumber'] : ''
        last_transaction_date = rm_tenant['Transactions'].present? ? rm_tenant['Transactions']&.last['TransactionDate'] : ''
        last_payment_date = rm_tenant['Payments'].present? ? rm_tenant['Payments']&.last['TransactionDate'] : ''

        RentManagerTenant.find_or_initialize_by(tenant_id: rm_tenant['TenantID'], location_id: rm_location_id).tap do |tenant|
          tenant.name = rm_tenant['Name']
          tenant.phone = phone
          tenant.status = rm_tenant['Status']
          tenant.property_id = rm_tenant['PropertyID']
          tenant.active_start_date = rm_tenant['PostingStartDate']
          tenant.active_end_date = rm_tenant['PostingEndDate']
          tenant.last_transaction_date = last_transaction_date
          tenant.last_payment_date = last_payment_date
          tenant.first_name = rm_tenant['FirstName']
          tenant.last_name = rm_tenant['LastName']
          tenant.email = email
        end.save!
      end

  end
end
