module Callfire
  class StylistsJob < ::Callfire::MainJob

    def perform
      http_client.start do |http|
        #get all contacts from the list
        req = Net::HTTP::Get.new('/api/1.1/rest/contact?MaxResults=10000&ContactListId=658274003')
        req.basic_auth ENV['CALLFIRE_USERNAME'], ENV['CALLFIRE_PASSWORD']

        doc = Nokogiri::XML(http.request(req).body)
        contact_ids = doc.css("Contact").map{ |c| c.attr('id') }

        # delete all contacts from the list
        req = Net::HTTP::Delete.new('/api/1.1/rest/contact')
        req.set_form_data({'ContactId' => contact_ids.join(' ')})
        req.basic_auth ENV['CALLFIRE_USERNAME'], ENV['CALLFIRE_PASSWORD']
        http.request(req)

        # re-add all active stylists to list
        Stylist.open.find_in_batches do |stylists|
          batch = {}

          stylists.each_with_index do |stylist, index|
            if stylist.name.present? && stylist.phone_number.present?
              batch["Contact[#{index}][firstName]"] = stylist.name
              batch["Contact[#{index}][homePhone]"] = stylist.phone_number
            end
          end

          req = Net::HTTP::Post.new('/api/1.1/rest/contact/list/658274003/add')
          req.set_form_data(batch)
          req.basic_auth ENV['CALLFIRE_USERNAME'], ENV['CALLFIRE_PASSWORD']
          http.request(req)
        end
      end

    end
  end
end
