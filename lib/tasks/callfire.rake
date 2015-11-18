namespace :callfire do


  task :stylists => :environment do
    #if Date.today.wday == 6
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
    #else
    #  p "today is not saturday"
    #end
  end

  task :franchises => :environment do
    #if Date.today.wday == 6
    Admin.where('callfire_app_login IS NOT NULL AND callfire_app_password IS NOT NULL').each do |admin|
      begin
        #gb = Gibbon::API.new(admin.mailchimp_api_key)
        all_list_ids = []
        
        admin.locations.each do |location|
          if location && location.callfire_list_ids && location.callfire_list_ids.present?
            callfire_list_ids = location.callfire_list_ids.split(',').collect(&:strip);

            all_list_ids = all_list_ids + callfire_list_ids if (callfire_list_ids && callfire_list_ids.size > 0)
          end
        end

        all_list_ids = all_list_ids.uniq
        p "all_list_ids = #{all_list_ids}"
        
        all_list_ids.each do |list_id|
          require 'net/https'
          http = Net::HTTP.new('www.callfire.com', 443)
          http.use_ssl = true

          http.start do |http|
            #get all contacts from the list
            req = Net::HTTP::Get.new("/api/1.1/rest/contact?MaxResults=10000&ContactListId=#{list_id.strip}")
            req.basic_auth admin.callfire_app_login, admin.callfire_app_password

            resp = http.request(req)

            doc = Nokogiri::XML(resp.body)
            contacts = doc.css("Contact")
            contact_ids = []
            contacts.each do |contact|
              contact_ids << contact.attr('id')
            end

            p "contact_ids=#{contact_ids}"

            #delete all contacts from the list
            req = Net::HTTP::Delete.new('/api/1.1/rest/contact')
            req.set_form_data({'ContactId' => contact_ids.join(' ')})
            req.basic_auth admin.callfire_app_login, admin.callfire_app_password

            resp = http.request(req)

            p "delete all contacts #{resp}"
          end
        end

        admin.locations.each do |location|
          if location.callfire_list_ids && location.callfire_list_ids.present? && location.stylists && location.stylists.size > 0
            p "Location #{location.name} has list ids #{location.callfire_list_ids} and #{location.stylists.size} stylists"

            list_ids = location.callfire_list_ids.split(',')
            p "list_ids=#{list_ids.inspect}"
            
            list_ids.each do |list_id|
              require 'net/https'
              http = Net::HTTP.new('www.callfire.com', 443)
              http.use_ssl = true

              http.start do |http|
                #add all active stylists to list
                batch = {}

                location.stylists.each_with_index do |stylist, index|
                  #p "Processing #{index} of #{stylists.size}"
                  if stylist && stylist.name.present? && stylist.phone_number.present?
                    batch["Contact[#{index}][firstName]"] = stylist.name
                    batch["Contact[#{index}][homePhone]"] = stylist.phone_number
                  else 
                    p "stylist doesnt have a phone #{stylist.phone_number}"
                  end
                end

                p "batch=#{batch.inspect}"

                req = Net::HTTP::Post.new("/api/1.1/rest/contact/list/#{list_id.strip}/add")
                req.set_form_data(batch)
                req.basic_auth admin.callfire_app_login, admin.callfire_app_password

                resp = http.request(req)
                if resp.is_a?(Net::HTTPNoContent)
                  p "saved to callfire successfully! #{resp}"
                else
                  p "problem saving to callfire, resp=#{resp}, #{batch.inspect}"
                end

              end
            end
          else
            p "No stylists or list ids for #{location.name}"
          end
        end
      rescue => e
        p "error processing franchise callfire #{admin.email}, #{e}"
      end
    end
    #else
    #  p "today is not saturday"
    #end    
  end

  # rake callfire:franchise['jeff@jeffbail.com']
  task :franchise, [:email] => [:environment] do |t, args|
    p "args[:email] = #{args[:email]}"
    Admin.where("callfire_app_login IS NOT NULL AND callfire_app_password IS NOT NULL AND email = ?", args[:email]).each do |admin|
      begin
        #gb = Gibbon::API.new(admin.mailchimp_api_key)
        all_list_ids = []
        
        admin.locations.each do |location|
          if location && location.callfire_list_ids && location.callfire_list_ids.present?
            callfire_list_ids = location.callfire_list_ids.split(',').collect(&:strip);

            all_list_ids = all_list_ids + callfire_list_ids if (callfire_list_ids && callfire_list_ids.size > 0)
          end
        end

        all_list_ids = all_list_ids.uniq
        p "all_list_ids = #{all_list_ids}"
        
        all_list_ids.each do |list_id|
          require 'net/https'
          http = Net::HTTP.new('www.callfire.com', 443)
          http.use_ssl = true

          http.start do |http|
            #get all contacts from the list
            req = Net::HTTP::Get.new("/api/1.1/rest/contact?MaxResults=10000&ContactListId=#{list_id.strip}")
            req.basic_auth admin.callfire_app_login, admin.callfire_app_password

            resp = http.request(req)

            doc = Nokogiri::XML(resp.body)
            contacts = doc.css("Contact")
            contact_ids = []
            contacts.each do |contact|
              contact_ids << contact.attr('id')
            end

            p "contact_ids=#{contact_ids}"

            #delete all contacts from the list
            req = Net::HTTP::Delete.new('/api/1.1/rest/contact')
            req.set_form_data({'ContactId' => contact_ids.join(' ')})
            req.basic_auth admin.callfire_app_login, admin.callfire_app_password

            resp = http.request(req)

            p "delete all contacts #{resp}"
          end
        end

        admin.locations.each do |location|
          if location.callfire_list_ids && location.callfire_list_ids.present? && location.stylists && location.stylists.size > 0
            p "Location #{location.name} has list ids #{location.callfire_list_ids} and #{location.stylists.size} stylists"

            list_ids = location.callfire_list_ids.split(',')
            p "list_ids=#{list_ids.inspect}"
            
            list_ids.each do |list_id|
              require 'net/https'
              http = Net::HTTP.new('www.callfire.com', 443)
              http.use_ssl = true

              http.start do |http|
                #add all active stylists to list
                batch = {}

                location.stylists.each_with_index do |stylist, index|
                  #p "Processing #{index} of #{stylists.size}"
                  if stylist && stylist.name.present? && stylist.phone_number.present?
                    batch["Contact[#{index}][firstName]"] = stylist.name
                    batch["Contact[#{index}][homePhone]"] = stylist.phone_number
                  else 
                    p "stylist doesnt have a phone #{stylist.phone_number}"
                  end
                end

                p "batch=#{batch.inspect}"

                req = Net::HTTP::Post.new("/api/1.1/rest/contact/list/#{list_id.strip}/add")
                req.set_form_data(batch)
                req.basic_auth admin.callfire_app_login, admin.callfire_app_password

                resp = http.request(req)
                if resp.is_a?(Net::HTTPNoContent)
                  p "saved to callfire successfully! #{resp}"
                else
                  p "problem saving to callfire, resp=#{resp}, #{batch.inspect}"
                end

              end
            end
          else
            p "No stylists or list ids for #{location.name}"
          end
        end
      rescue => e
        p "error processing franchise callfire #{admin.email}, #{e}"
      end
    end  
  end

end