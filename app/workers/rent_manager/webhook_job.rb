module RentManager
  class WebhookJob
    include Sidekiq::Worker

    sidekiq_options(
      queue: :rent_manager_webhook,
      retry: 3,
      unique: :until_executed,
      unique_expiration: 3.days,
      backtrace: true
    )

    def perform(event_id)
      event = RentManager::Event.find(event_id)
      return unless event.queued?

      event_type = event.body['EventType']
      @tenant_id = event.body['IDParentIDDict']&.keys&.first
      @rm_location_id = event.body['LocationID']

      event.failed! && return if @tenant_id.blank? || @rm_location_id.blank?

      case event_type
      when 'Tenant_Edit', 'Tenant_Delete'
        @stylist = ExternalId.find_stylist_by(@rm_location_id, @tenant_id)

        return if @stylist.blank?

        if event_type == 'Tenant_Delete'
          stylist_inactive!
        else
          update_stylist
        end
      when 'Tenant_Add'
        create_stylist
      end

      event.update!(object: @stylist)
      event.processed!
    rescue => e
      if event.present?
        event.update(status_message: e.message, status: 'failed')
      end
    end

    private

    def client
      @client ||= ::Rentmanager::Client.new
    end

    def create_stylist
      return if location.blank?

      #password = SecureRandom.alphanumeric(6)
      #stylist_attributes.merge({ password: password, password_confirmation: password })
      @stylist = Stylist.create!(stylist_attributes)
      @stylist.external_ids
             .rent_manager
             .find_or_initialize_by(name: :tenant_id, rm_location_id: @rm_location_id).tap do |e_id|
        e_id.value = @tenant_id
      end.save!
      event.update!(object: @stylist)
      #PublicWebsiteMailer.password(@stylist, password).deliver_now if @stylist.persisted?
    end

    def update_stylist
      @stylist.update(stylist_attributes)
    end

    def stylist_inactive!
      @stylist.update!(status: 'closed', inactive_reason: 'left', from_webhook: true)
    end

    def rm_tenant
      @rm_tenant ||= client.tenant(@rm_location_id, @tenant_id)
    end

    def location
      @location ||= ExternalId.find_location_by(@rm_location_id, rm_tenant['PropertyID'])
    end

    def stylist_attributes
      {
        name: rm_tenant['Name'],
        email_address: rm_tenant['Contacts'].first['Email'],
        phone_number: rm_tenant['Contacts'].first['PhoneNumbers']&.map{|pn| pn['StrippedPhoneNumber'] }&.first,
        rm_status: rm_tenant['Status'],
        location_id: location&.id,
        from_webhook: true,
        reserved: true
      }.compact
    end
  end
end

