module Callfire
  class FranchisesJob < ::Callfire::MainJob

    def perform(email = nil)
      scope = Admin.with_callfire_credentials
      scope = scope.where(email_address: email) if email.present?
      scope.each do |admin|
        begin
          cleanup(admin)
          push(admin)
        rescue => e
          NewRelic::Agent.notice_error(e)
        end
      end
    end

    private

    def cleanup(admin)
      all_list_ids = admin.locations.
        with_callfire_ids.
        pluck(:callfire_list_ids).
        map{ |i| i.split(',').collect(&:strip) }.
        flatten.uniq.compact.reject { |c| c.empty? }

      all_list_ids.each do |list_id|
        http_client.start do |http|
          #get all contacts from the list
          req = Net::HTTP::Get.new("/api/1.1/rest/contact?MaxResults=10000&ContactListId=#{list_id}")
          req.basic_auth admin.callfire_app_login, admin.callfire_app_password

          resp = http.request(req)
          next if resp.class != Net::HTTPOK
          doc = Nokogiri::XML(resp.body)
          contact_ids = doc.css("Contact").map{ |c| c.attr('id') }
          #delete all contacts from the list
          req = Net::HTTP::Delete.new('/api/1.1/rest/contact')
          req.set_form_data({'ContactId' => contact_ids.join(' ')})
          req.basic_auth admin.callfire_app_login, admin.callfire_app_password
          http.request(req)
        end
      end
    end

    def push(admin)
      admin.locations.with_callfire_ids.find_each do |location|
        next if location.callfire_list_ids.blank?
        next unless location.stylists.exists?

        location.callfire_list_ids.split(',').each do |list_id|
          http_client.start do |http|
            batch = {}

            location.stylists.each_with_index do |stylist, index|
              next if stylist.name.blak? || stylist.phone_number.blank?

              batch["Contact[#{index}][firstName]"] = stylist.name
              batch["Contact[#{index}][homePhone]"] = stylist.phone_number
            end

            req = Net::HTTP::Post.new("/api/1.1/rest/contact/list/#{list_id.strip}/add")
            req.set_form_data(batch)
            req.basic_auth admin.callfire_app_login, admin.callfire_app_password
            http.request(req)
          end
        end
      end
    end
  end
end
