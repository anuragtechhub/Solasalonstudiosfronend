namespace :mailchimp do

  task :contact_forms => :environment do
    gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')

    FranchisingRequest.all.each do |req|
      if req && req.email.present?
        p "FranchisingRequest #{req.email}"
        begin
          gb.lists.subscribe({:id => '09d9824082', :email => {:email => req.email}, :merge_vars => {}, :double_optin => false})
        rescue => e
          Rollbar.error(e)
          NewRelic::Agent.notice_error(e)
          p "FranchisingRequest error adding mailchimp #{e}"
        end
      end
    end

    RequestTourInquiry.all.each do |req|
      if req && req.email.present?
        p "RequestTourInquiry #{req.email}"
        begin
          gb.lists.subscribe({:id => '09d9824082', :email => {:email => req.email}, :merge_vars => {}, :double_optin => false})
        rescue => e
          Rollbar.error(e)
          NewRelic::Agent.notice_error(e)
          p "RequestTourInquiry error adding mailchimp #{e}"
        end
      end
    end

    PartnerInquiry.all.each do |req|
      if req && req.email.present?
        p "PartnerInquiry #{req.email}"
        begin
          gb.lists.subscribe({:id => '09d9824082', :email => {:email => req.email}, :merge_vars => {}, :double_optin => false})
        rescue => e
          Rollbar.error(e)
          NewRelic::Agent.notice_error(e)
          p "PartnerInquiry error adding mailchimp #{e}"
        end
      end
    end

  end

  # USA - e5443d78c6
  # Canada - 31fd8d62f9

  task :stylists => :environment do
    gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')

    # USA
    Stylist.joins(:location).where('locations.country = ? AND stylists.status = ?', 'US', 'open').find_in_batches do |stylists|
      batch = []

      stylists.each_with_index do |stylist, index|
        p "Processing #{index} of #{stylists.size}"
        if stylist && stylist.email_address && stylist.location
          data = {}

          data[:email] = {:email => stylist.email_address}
          data[:merge_vars] = {:MERGE3 => stylist.name, :MERGE5 => stylist.phone_number, :MERGE6 => stylist.location.name, :MMERGE8 => stylist.location.state}

          batch << data
        end
      end

      p "batch.size=#{batch.size}"
      #p "batch=#{batch.inspect}"
      gb.lists.batch_subscribe(:id => 'e5443d78c6', :batch => batch, :double_optin => false, :update_existing => true)
    end

    # Canada
    Stylist.joins(:location).where('locations.country = ? AND stylists.status = ?', 'CA', 'open').find_in_batches do |stylists|
      batch = []

      stylists.each_with_index do |stylist, index|
        p "Processing #{index} of #{stylists.size}"
        if stylist && stylist.email_address && stylist.location
          data = {}

          data[:email] = {:email => stylist.email_address}
          data[:merge_vars] = {:MERGE3 => stylist.name, :MERGE5 => stylist.phone_number, :MERGE6 => stylist.location.name, :MMERGE8 => stylist.location.state}

          batch << data
        end
      end

      p "batch.size=#{batch.size}"
      #p "batch=#{batch.inspect}"
      gb.lists.batch_subscribe(:id => '31fd8d62f9', :batch => batch, :double_optin => false, :update_existing => true)
    end
  end

  task :today => :environment do
    gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')

    Stylist.where('status = ? AND created_at >= ?', 'open', Date.today.prev_day).find_in_batches do |stylists|
      batch = []

      stylists.each_with_index do |stylist, index|
        p "Processing #{index} of #{stylists.size}"
        if stylist && stylist.email_address && stylist.location
          data = {}

          data[:email] = {:email => stylist.email_address}
          data[:merge_vars] = {:MERGE3 => stylist.name, :MERGE5 => stylist.phone_number, :MERGE6 => stylist.location.name, :MMERGE8 => stylist.location.state}

          batch << data
        end
      end

      p "batch.size=#{batch.size}"
      p "batch=#{batch.inspect}"
      gb.lists.batch_subscribe(:id => 'e5443d78c6', :batch => batch, :double_optin => false, :update_existing => true)
    end
  end
end
