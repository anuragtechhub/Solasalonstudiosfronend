# frozen_string_literal: true

module RentManager
  class StylistSyncJob
    include Sidekiq::Worker

    sidekiq_options(
      queue:             :rent_manager,
      retry:             3,
      unique:            :until_executed,
      unique_expiration: 3.days,
      backtrace:         true
    )

    def perform(stylist_id)
      @stylist = Stylist.find(stylist_id)

      @stylist.external_ids.rent_manager.where(name: 'tenant_id').find_each do |external_id|
        current_rm_values = client.tenant(external_id.rm_location_id, external_id.value)

        client.tenants_save(external_id.rm_location_id, attributes(external_id.value, current_rm_values))
      end
    end

    private

      def attributes(tenant_id, current_rm_values)
        [{
          TenantID:   tenant_id,
          Name:       @stylist.name,
          FirstName:  @stylist.first_name,
          LastName:   @stylist.last_name,
          PropertyID: current_rm_values['PropertyID'],
          RentPeriod: current_rm_values['RentPeriod'],
          RentDueDay: current_rm_values['RentDueDay'],
          Contacts:   [
            {
              ContactID:    current_rm_values['Contacts'].first['ContactID'],
              FirstName:    @stylist.first_name,
              LastName:     @stylist.last_name,
              IsPrimary:    true,
              Email:        @stylist.email_address,
              PhoneNumbers: [
                {
                  PhoneNumberID:     current_rm_values['Contacts']&.first['PhoneNumbers']&.first.try('[]', 'PhoneNumberID'),
                  PhoneNumberTypeID: current_rm_values['Contacts']&.first['PhoneNumbers']&.first.try('[]', 'PhoneNumberTypeID').presence || 1,
                  PhoneNumber:       @stylist.phone_number,
                  IsPrimary:         true,
                  ParentID:          current_rm_values['Contacts'].first['ContactID'],
                  ParentType:        'Contact'
                }.compact
              ]
            }
          ]
        }]
      end

      def client
        @client ||= ::Rentmanager::Client.new
      end
  end
end
