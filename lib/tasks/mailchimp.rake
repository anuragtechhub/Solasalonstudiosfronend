namespace :mailchimp do

  task :stylists => :environment do
    gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')

    Stylist.where(:status => 'open').find_in_batches do |stylists|
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
      gb.lists.batch_subscribe(:id => 'e5443d78c6', :batch => batch, :update_existing => true)
    end
  end

end