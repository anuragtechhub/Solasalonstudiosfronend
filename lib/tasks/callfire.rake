namespace :callfire do

  # task :stylists => :environment do
  #   if Date.today.wday == 1
  #     #gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')

  #     Stylist.where(:status => 'open').find_in_batches do |stylists|
  #       batch = []

  #       stylists.each_with_index do |stylist, index|
  #         p "Processing #{index} of #{stylists.size}"
  #         if stylist && stylist.email_address && stylist.location
  #           data = {}
            
  #           data[:email] = {:email => stylist.email_address}
  #           data[:merge_vars] = {:MERGE3 => stylist.name, :MERGE5 => stylist.phone_number, :MERGE6 => stylist.location.name, :MMERGE8 => stylist.location.state}

  #           batch << data
  #         end
  #       end

  #       p "batch.size=#{batch.size}"
  #       #p "batch=#{batch.inspect}"
  #       #gb.lists.batch_subscribe(:id => 'e5443d78c6', :batch => batch, :update_existing => true)
  #     end
  #   else
  #     p "today is not saturday"
  #   end
  # end

  task :stylists => :environment do
    if Date.today.wday == 1
      require 'net/https'
      http = Net::HTTP.new('www.callfire.com', 443)
      http.use_ssl = true

      http.start do |http|
        #get all contacts from the list
        req = Net::HTTP::Get.new('/api/1.1/rest/contact?MaxResults=10000&ContactListId=658274003')
        req.basic_auth '3d94e1daf427', 'bf76e377929906d7'

        resp = http.request(req)

        doc = Nokogiri::XML(resp.body)
        contacts = doc.css("Contact")
        contact_ids = []
        contacts.each do |contact|
          contact_ids << contact.attr('id')
        end

        #delete all contacts from the list
        req = Net::HTTP::Delete.new('/api/1.1/rest/contact')
        req.set_form_data({'ContactId' => contact_ids.join(' ')})
        req.basic_auth '3d94e1daf427', 'bf76e377929906d7'

        resp = http.request(req)

        p "delete all contacts #{resp}"

        #re-add all active stylists to list
        Stylist.where(:status => 'open').find_in_batches do |stylists|
          batch = {}

          stylists.each_with_index do |stylist, index|
            #p "Processing #{index} of #{stylists.size}"
            if stylist && stylist.name.present? && stylist.phone_number.present?
              batch["Contact[#{index}][firstName]"] = stylist.name
              batch["Contact[#{index}][homePhone]"] = stylist.phone_number
            end
          end

          #p "batch.size=#{batch.size}"
          #p "batch=#{batch.inspect}"

          req = Net::HTTP::Post.new('/api/1.1/rest/contact/list/658274003/add')
          req.set_form_data(batch)
          req.basic_auth '3d94e1daf427', 'bf76e377929906d7'

          resp = http.request(req)
          if resp.is_a?(Net::HTTPNoContent)
            p 'saved to callfire successfully!'
          else
            p "problem saving to callfire, resp=#{resp}, #{batch.inspect}"
          end
        end

      end
    else
      p "today is not saturday"
    end
  end

end