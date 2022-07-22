# frozen_string_literal: true

module Callfire
  class StylistsJob < ::Callfire::MainJob
    def perform
      http_client.start do |http|
        # get all contacts from the list
        req = Net::HTTP::Get.new('/api/1.1/rest/contact?MaxResults=10000&ContactListId=658274003')
        req.basic_auth ENV.fetch('CALLFIRE_USERNAME', nil), ENV.fetch('CALLFIRE_PASSWORD', nil)

        doc = Nokogiri::XML(http.request(req).body)
        contact_ids = doc.css('Contact').map { |c| c.attr('id') }

        # delete all contacts from the list
        req = Net::HTTP::Delete.new('/api/1.1/rest/contact')
        req.set_form_data({ 'ContactId' => contact_ids.join(' ') })
        req.basic_auth ENV.fetch('CALLFIRE_USERNAME', nil), ENV.fetch('CALLFIRE_PASSWORD', nil)
        http.request(req)

        # re-add all active stylists to list
        Stylist.open.find_in_batches do |stylists|
          batch = {}

          stylists.each_with_index do |stylist, index|
            next if stylist.name.blank? || stylist.phone_number.blank?

            batch["Contact[#{index}][firstName]"] = stylist.name
            batch["Contact[#{index}][homePhone]"] = stylist.phone_number
            data = {
              name: stylist.name,
              phone_number: stylist.phone_number
            }
            CallfireLog.create(status: 'success', data: data, kind: 'callfire_stylist_job', action: 'form')
            ScheduledJobLog.create(status: 'success', data: data, kind: 'callfire_stylist_job', fired_at: Time.current)
            
          end

          req = Net::HTTP::Post.new('/api/1.1/rest/contact/list/658274003/add')
          req.set_form_data(batch)
          req.basic_auth ENV.fetch('CALLFIRE_USERNAME', nil), ENV.fetch('CALLFIRE_PASSWORD', nil)
          http.request(req)
        end
      end
    end
  end
end
