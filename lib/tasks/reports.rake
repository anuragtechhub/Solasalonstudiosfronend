namespace :reports do

  require 'google/apis/analyticsreporting_v4'
  require 'render_anywhere'

  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  # task :pdf => :environment do
  #   html_renderer = HTMLRenderer.new

  #   locals = {
  #     :@name => 'Jeff'
  #   }

  #   p "pdf! #{html_renderer.build_html(locals)}"
  #   pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/test', locals), :footer => {:center => '[page]', :font_size => 7})

  #   save_path = Rails.root.join('pdfs','report.pdf')
  #   File.open(save_path, 'wb') do |file|
  #     file << pdf
  #   end    
  # end

  # rake reports:locations_contact_form_submissions[2018-01-01,2018-12-01,"jeff@jeffbail.com"]
  # rake reports:locations_contact_form_submissions[2017-11-01,2017-12-01,"jeff@jeffbail.com jeff+1@jeffbail.com jeff+2@jeffbail.com"]
  task :locations_contact_form_submissions, [:start_date, :end_date, :email_addresses] => :environment do |task, args|
    p "Begin location_contact_form_submission task...#{args.email_addresses}"
    
    start_date = args.start_date.present? ? Date.parse(args.start_date).beginning_of_month : DateTime.now.prev_month.beginning_of_month
    end_date = args.end_date.present? ? Date.parse(args.end_date).beginning_of_month : start_date.end_of_month
    email_addresses = args.email_addresses.split(' ')

    p "start_date=#{start_date}, end_date=#{end_date}, email_addresses=#{email_addresses}"

    csv_report = CSV.generate do |csv|
      csv << ['Month', 'Location', 'Contact Form Submissions']

      locations = Location.open.order(:name => :asc).to_a
      months = (start_date..end_date).select {|d| d.day == 1}
      months.each do |month|
        p "month=#{month}"
        locations.each do |location|
          csv << [month.strftime('%B %Y'), location.name, RequestTourInquiry.where('location_id = ? AND (created_at <= ? AND created_at >= ?)', location.id, month.end_of_month, month.beginning_of_month).count]
        end
      end

    end

    mail = ReportsMailer.location_contact_form_submission_report(email_addresses, csv_report, start_date, end_date).deliver
  end

  task :request_tour_inquiries => :environment do
    jan_1 = Date.new(2019, 3, 1)
    today = Date.today
    rtis = RequestTourInquiry.where(:created_at => (jan_1..today))
    
    save_path = Rails.root.join('csvs','request_tour_inquiries.csv')
    CSV.open(save_path, "wb") do |csv|
      csv << ["Name", "Email", "Phone", "Message", "URL", "Created At", "Location Name"]
      rtis.each do |rti|
        if rti.location
          csv << [rti.name, rti.email, rti.phone, rti.message, rti.request_url, rti.created_at, rti.location.name]
        end
      end
    end
  end

  task :locations_by_state => :environment do
    p "ID,NAME,EMAIL,PHONE,LOCATION"
    Stylist.where('status = ? AND location_id IN (?)', 'open', Location.near('San Diego, CA').map(&:id)).each do |stylist|
      p "#{stylist.id},#{stylist.name},#{stylist.email_address},#{stylist.phone_number},#{stylist.location.name}"
    end
  end

  # compiles and sends unprocessed Reports
  task :process_unprocessed => :environment do 
    Report.where(:processed_at => nil).each do |report|
      if report.report_type == 'all_locations'
        send_all_locations_report(report.email_address)
      elsif report.report_type == 'all_stylists'
        send_all_stylists_report(report.email_address)
      elsif report.report_type == 'solapro_solagenius_penetration'
        send_solapro_solagenius_penetration_report(report.email_address)
      end
      report.processed_at = DateTime.now
      report.save
    end
  end

  # rake reports:locations
  # rake reports:locations[2019-01-01]
  task :locations, [:start_date] => :environment do |task, args|
    p "begin locations report..."
    
    start_date = args.start_date.present? ? Date.parse(args.start_date).beginning_of_month : DateTime.now.prev_month.beginning_of_month
    end_date = start_date.end_of_month    

    Location.where(:status => :open).order(:created_at => :asc).each do |location|
      p "START location=#{location.id}, #{location.name}"

      location_ga_report(location, start_date, end_date, false)
      p "FINISHED WITH location=#{location.id}, #{location.name}"
    end
  end 

  # rake reports:locations_with_email
  # rake reports:locations_with_email[2017-12-01]
  task :locations_with_email, [:start_date] => :environment do |task, args|
    p "begin locations report..."
    
    start_date = args.start_date.present? ? Date.parse(args.start_date).beginning_of_month : DateTime.now.prev_month.beginning_of_month
    end_date = start_date.end_of_month    

    Location.where(:status => :open).order(:id => :asc).each do |location|
      sleep 1
      p "START location=#{location.id}, #{location.name}"
      begin
        location_ga_report(location, start_date, end_date, true)
        p "FINISHED WITH location=#{location.id}, #{location.name}"

      rescue Exception => e
        p "ERROR with location=#{location.id}, #{location.name}, #{e.inspect}"
      end
    end
  end 

  # rake reports:locations_with_email_starting_at
  # rake reports:locations_with_email_starting_at[2017-12-01,343]
  task :locations_with_email_starting_at, [:start_date, :gid] => :environment do |task, args|
    p "begin locations report..."
    
    start_date = args.start_date.present? ? Date.parse(args.start_date).beginning_of_month : DateTime.now.prev_month.beginning_of_month
    end_date = start_date.end_of_month    

    Location.where(:status => :open).where('id >= ?', args.gid).order(:id => :asc).uniq.each do |location|
      sleep 1
      p "START location=#{location.id}, #{location.name}"
      begin
        location_ga_report(location, start_date, end_date, true)
        p "FINISHED WITH location=#{location.id}, #{location.name}"
      rescue Exception => e
        p "ERROR with location=#{location.id}, #{location.name}, #{e.inspect}"
      end
    end
  end 

  # rake reports:location[401]
  # rake reports:location[2]
  # rake reports:location[2,2018-12-01]
  task :location, [:location_id, :start_date] => :environment do |task, args|
    p "begin location report..."

    location = Location.find(args.location_id) if args.location_id.present?
    start_date = args.start_date.present? ? Date.parse(args.start_date).beginning_of_month : DateTime.now.prev_month.beginning_of_month
    end_date = start_date.end_of_month

    p "location=#{location.id}, #{location.name}"
    p "start_date=#{start_date.inspect}"
    p "end_date=#{end_date.inspect}"

    if location && start_date && end_date
      location_ga_report(location, start_date, end_date, false)
    end
  end

  # rake reports:location_with_email[380]
  # rake reports:location_with_email[2]
  # rake reports:location_with_email[8,2017-07-01]
  task :location_with_email, [:location_id, :start_date] => :environment do |task, args|
    p "begin location with email report..."

    location = Location.find(args.location_id) if args.location_id.present?
    start_date = args.start_date.present? ? Date.parse(args.start_date).beginning_of_month : DateTime.now.prev_month.beginning_of_month
    end_date = start_date.end_of_month

    p "location=#{location.id}, #{location.name}"
    p "start_date=#{start_date.inspect}"
    p "end_date=#{end_date.inspect}"

    if location && start_date && end_date
      location_ga_report(location, start_date, end_date, true)
    end
  end

  # rake reports:booknow_biweekly["olivia@solasalonstudios.com"]
  task :booknow_biweekly, [:email_address] => :environment do |task, args|
    if Time.now.day == 14 || Time.now.day == 28
      start_date = DateTime.now
      end_date = start_date - 14.days

      analytics = Analytics.new
      if start_date && end_date
        #web_data = analytics.solapro_web_data('105609602', start_date, end_date)
        app_data = analytics.booknow_data('81802112', start_date, end_date)
      else
        #web_data = analytics.solapro_web_data
        app_data = analytics.booknow_data
      end
      locals = {
        :@app_data => app_data,
        #:@web_data => web_data
      }

      p "got data #{locals.inspect}"
      p "got data..."

      html_renderer = HTMLRenderer.new

      p "let's render PDF"
      pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/booknow_ga', locals), :footer => {:center => '[page]', :font_size => 7})
      p "pdf rendered..."

      if args[:email_address].present?
        p "send email..."
        ReportsMailer.booknow_report(args[:email_address], pdf).deliver
      else
        save_path = Rails.root.join('pdfs','booknow.pdf')
        File.open(save_path, 'wb') do |file|
          file << pdf
        end   
        p "file saved" 
      end
    end
  end

  # rake reports:booknow
  # rake reports:booknow[2019-01-01] || rake reports:booknow[2019-01-01,"jeff@jeffbail.com"]
  task :booknow, [:start_date, :email_address] => :environment do |task, args|
    p "begin booknow analytics report..."
    # p "args=#{args.inspect}"
    # p "args.start_date=#{args.start_date}, args.end_date=#{args.end_date}"
    start_date = Date.parse(args.start_date).beginning_of_month if args.start_date.present?
    end_date = start_date.end_of_month if start_date

    analytics = Analytics.new
    if start_date && end_date
      #web_data = analytics.solapro_web_data('105609602', start_date, end_date)
      app_data = analytics.booknow_data('81802112', start_date, end_date)
    else
      #web_data = analytics.solapro_web_data
      app_data = analytics.booknow_data
    end
    locals = {
      :@app_data => app_data,
      #:@web_data => web_data
    }

    p "got data #{locals.inspect}"
    p "got data..."

    html_renderer = HTMLRenderer.new

    p "let's render PDF"
    pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/booknow_ga', locals), :footer => {:center => '[page]', :font_size => 7})
    p "pdf rendered..."

    if args[:email_address].present?
      p "send email..."
      ReportsMailer.booknow_report(args[:email_address], pdf).deliver
    else
      save_path = Rails.root.join('pdfs','booknow.pdf')
      File.open(save_path, 'wb') do |file|
        file << pdf
      end   
      p "file saved" 
    end
  end

  # rake reports:solapro
  # rake reports:solapro[2017-12-01]
  task :solapro, [:start_date] => :environment do |task, args|
    p "begin solapro analytics report..."
    # p "args=#{args.inspect}"
    # p "args.start_date=#{args.start_date}, args.end_date=#{args.end_date}"
    start_date = Date.parse(args.start_date).beginning_of_month if args.start_date.present?
    end_date = start_date.end_of_month if start_date
    # puts ARGV.inspect
    # start_date = Date.parse ARGV[1] if ARGV && ARGV.length == 3
    # end_date = Date.parse ARGV[2] if ARGV && ARGV.length == 3

    analytics = Analytics.new
    if start_date && end_date
      #web_data = analytics.solapro_web_data('105609602', start_date, end_date)
      app_data = analytics.solapro_app_data('113771223', start_date, end_date)
    else
      #web_data = analytics.solapro_web_data
      app_data = analytics.solapro_app_data
    end
    locals = {
      :@app_data => app_data,
      #:@web_data => web_data
    }

    p "got data #{locals.inspect}"
    p "got data..."

    html_renderer = HTMLRenderer.new

    p "let's render PDF"
    pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/solapro_ga', locals), :footer => {:center => '[page]', :font_size => 7})
    p "pdf rendered..."
    save_path = Rails.root.join('pdfs','solapro.pdf')
    File.open(save_path, 'wb') do |file|
      file << pdf
    end   
    p "file saved" 
  end

  # rake reports:solasalonstudios
  # rake reports:solasalonstudios[2018-11-01]
  task :solasalonstudios, [:start_date] => :environment do |task, args|
    p "begin solasalonstudios analytics report..."
    # p "args=#{args.inspect}"
    # p "args.start_date=#{args.start_date}, args.end_date=#{args.end_date}"
    start_date = Date.parse(args.start_date).beginning_of_month if args.start_date.present?
    end_date = start_date.end_of_month if start_date
    # puts ARGV.inspect
    # start_date = Date.parse ARGV[1] if ARGV && ARGV.length == 3
    # end_date = Date.parse ARGV[2] if ARGV && ARGV.length == 3

    analytics = Analytics.new
    if start_date && end_date
      data = analytics.solasalonstudios_data('81802112', start_date, end_date)
    else
      data = analytics.solasalonstudios_data
    end
    locals = {
      :@data => data
    }

    p "got data #{locals.inspect}"
    p "got data..."

    html_renderer = HTMLRenderer.new

    p "let's render PDF"
    pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/solasalonstudios_ga', locals), :footer => {:center => '[page]', :font_size => 7})
    p "pdf rendered..."
    save_path = Rails.root.join('pdfs','solasalonstudios.pdf')
    File.open(save_path, 'wb') do |file|
      file << pdf
    end   
    p "file saved" 
  end


  ##### helper functions #######
  def power_of_now(arr=[])
    arr.each_with_index do |i, idx|
      arr[idx] = i.present? ? i : " "
    end

    return arr
  end

  def send_all_locations_report(email_address=nil)
    return unless email_address
    p "send all locations"
    
    csv_report = CSV.generate do |csv|
      csv << ['ID', 'Name', 'URL Name', 'Address 1', 'Address 2', 'City', 'State', 'Postal Code', 'Country', 'Email Address', 'Phone Number', 'Contact Name', 'Description', 
              'Facebook URL', 'Pinterest URL', 'Instagram URL', 'Twitter URL', 'Yelp URL', 'Move In Special', 'Open House']
      
      Location.where('status = ?', 'open').order(:created_at => :desc).each do |location|
        csv << power_of_now([location.id, location.name, location.url_name, location.address_1, location.address_2, location.city, location.state, location.postal_code, location.country,
                location.email_address_for_inquiries, location.phone_number, location.general_contact_name, location.description, location.facebook_url, location.pinterest_url, 
                location.instagram_url, location.twitter_url, location.yelp_url, location.move_in_special, location.open_house])
      end
    end

    #p "csv_report=#{csv_report}"

    mail = ReportsMailer.send_report(email_address, 'All Locations Report', csv_report).deliver
    #p "mail?=#{mail}"
    #mail.deliver
  end

  def send_all_stylists_report(email_address=nil)
    return unless email_address
    p "send all stylists"
    
    csv_report = CSV.generate do |csv|
      csv << ['ID', 'First Name', 'Last Name', 'URL Name', 'Email Address', 'Phone Number', 'Website URL', 'Booking URL', 'SolaGenius Booking URL',
              'Pinterest URL', 'Facebook URL', 'Twitter URL', 'Instagram URL', 'Yelp URL', 
              'Emergency Contact Name', 'Emergency Contact Relationship', 'Emergency Contact Phone Number', 
              'Brows', 'Hair', 'Hair Exensions', 'Laser Hair Removal', 'Lashes', 'Makeup', 'Massage', 'Microblading', 
              'Nails', 'Permanent Makeup', 'Skincare', 'Tanning', 'Teeth Whitening', 'Threading', 'Waxing', 'Other Service', 
              'Studio Number', 'Location ID', 'Location Name', 'Location City', 'Location State', 'Country', 'Has Sola Pro', 'Has SolaGenius']

      Stylist.where('status = ?', 'open').order(:created_at => :desc).each do |stylist|
        next unless stylist && stylist.location
        #p "stylist=#{stylist.inspect}"
        csv << power_of_now([stylist.id, stylist.first_name, stylist.last_name, stylist.url_name, stylist.email_address, stylist.phone_number, stylist.website_url, stylist.booking_url, stylist.sg_booking_url,
                stylist.pinterest_url, stylist.facebook_url, stylist.twitter_url, stylist.instagram_url, stylist.yelp_url,
                stylist.emergency_contact_name, stylist.emergency_contact_relationship, stylist.emergency_contact_phone_number, 
                stylist.brows, stylist.hair, stylist.hair_extensions, stylist.laser_hair_removal, stylist.eyelash_extensions, stylist.makeup, stylist.massage, stylist.microblading,
                stylist.nails, stylist.permanent_makeup, stylist.skin, stylist.tanning, stylist.teeth_whitening, stylist.threading, stylist.waxing, stylist.other_service,
                stylist.studio_number, stylist.location.id, stylist.location.name, stylist.location.city, stylist.location.state, stylist.country, stylist.has_sola_pro_login, stylist.has_sola_genius_account])
      end
    end

    #p "csv_report=#{csv_report}"

    mail = ReportsMailer.send_report(email_address, 'All Stylists Report', csv_report).deliver
    #p "mail?=#{mail}"
    #mail.deliver
  end

  def send_solapro_solagenius_penetration_report(email_address=nil)
    return unless email_address
    p "send solapro solagenius penetration"
    
    csv_report = CSV.generate do |csv|
      csv << ['Location ID', 'Location Name', 'Location City', 'Location State', 'Stylists on Website', 'Has Sola Pro Account', 'Has SolaGenius Account']
      Location.where('status = ?', 'open').order(:created_at => :desc).each do |location|
        csv << power_of_now([location.id, location.name, location.city, location.state, location.stylists.size, location.stylists_using_sola_pro.size, location.stylists_using_sola_genius.size])
      end
    end

    #p "csv_report=#{csv_report}"

    mail = ReportsMailer.send_report(email_address, 'Sola Pro / SolaGenius Penetration Report', csv_report).deliver
    #p "mail?=#{mail}"
    #mail.deliver
  end


  ##### report functions #######

  def location_ga_report(location, start_date, end_date, send_email=false)
    analytics = Analytics.new
    if start_date && end_date
      data = analytics.location_data('81802112', location, start_date, end_date)
    else
      data = analytics.location_data
    end

    # sola pro, sola genius, etc numbers
    data[:salon_professionals_on_sola_website] = location.stylists.size
    data[:salon_professionals_on_solagenius] = location.stylists.select{|s| s.has_sola_genius_account }.size
    data[:salon_professionals_on_sola_pro] = location.stylists.where("encrypted_password IS NOT NULL AND encrypted_password <> ''").size

    # contact form submissions
    data[:contact_form_submissions_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ?)', start_date, end_date, location.id).count
    data[:contact_form_submissions_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ?)', start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, location.id).count
    data[:contact_form_submissions_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ?)', (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month, location.id).count

    #data[:contact_form_submissions_prev_month] = 1 if data[:contact_form_submissions_prev_month] == 0
    #data[:contact_form_submissions_prev_year] = 1 if data[:contact_form_submissions_prev_year] == 0

    locals = {
      :@data => data
    }

    p "got data #{locals.inspect}"
    p "got data..."

    html_renderer = HTMLRenderer.new

    p "let's render PDF"
    pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/location_ga', locals), :footer => {:center => '[page]', :font_size => 7})
    p "pdf rendered..."
    
    if send_email
      p "send email..."
      ReportsMailer.location_report(location, pdf).deliver
      p "email sent"
    else
      p "save file..."
      save_path = Rails.root.join('pdfs',"location_#{location.url_name}.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end  
      p "file saved" 
    end 
  end



  ####### html renderer #######

  class HTMLRenderer
    include RenderAnywhere

    def build_html(template='reports/test', locals={})
      html = render :template => template,
                    :layout => 'reports',
                    :locals => locals
      html
    end
    # Include an additional helper
    # If being used in a rake task, you may need to require the file(s)
    # Ex: require Rails.root.join('app', 'helpers', 'blog_pages_helper')
    def include_helper(helper_name)
      set_render_anywhere_helpers(helper_name)
    end

    # Apply an instance variable to the controller
    # If you need to use instance variables instead of locals, just call this method as many times as you need.
    def set_instance_variable(var, value)
      set_instance_variable(var, value)
    end

    class RenderingController < RenderAnywhere::RenderingController
      # # include custom modules here, define accessors, etc. For example:
      # attr_accessor :current_user
      # helper_method :current_user
    end

    # If you define custom RenderingController, don't forget to override this method
    def rendering_controller
      @rendering_controller ||= self.class.const_get("RenderingController").new
    end
  end

  ####### base_cli.rb #######

  require 'googleauth'
  require 'googleauth/stores/file_token_store'
  require 'fileutils'
  require 'thor'
  require 'os'

  # Base command line module for samples. Provides authorization support,
  # either using application default credentials or user authorization
  # depending on the use case.
  class BaseCli < Thor
    include Thor::Actions

    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

    class_option :user, :type => :string
    class_option :api_key, :type => :string

    no_commands do

      # Returns the path to the client_secrets.json file.
      def client_secrets_path
        return ENV['GOOGLE_CLIENT_SECRETS'] if ENV.has_key?('GOOGLE_CLIENT_SECRETS')
        return well_known_path_for('client_secrets.json')
      end

      # Returns the path to the token store.
      def token_store_path
        return ENV['GOOGLE_CREDENTIAL_STORE'] if ENV.has_key?('GOOGLE_CREDENTIAL_STORE')
        return well_known_path_for('credentials.yaml')
      end

      # Builds a path to a file in $HOME/.config/google (or %APPDATA%/google,
      # on Windows)
      def well_known_path_for(file)
        if OS.windows?
          dir = ENV.fetch('HOME'){ ENV['APPDATA']}
          File.join(dir, 'google', file)
        else
          File.join(ENV['HOME'], '.config', 'google', file)
        end
      end

      # Returns application credentials for the given scope.
      def application_credentials_for(scope)
        Google::Auth.get_application_default(scope)
      end

      # Returns user credentials for the given scope. Requests authorization
      # if requrired.
      def user_credentials_for(scope)
        FileUtils.mkdir_p(File.dirname(token_store_path))

        if ENV['GOOGLE_CLIENT_ID']
          client_id = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])
        else
          client_id = Google::Auth::ClientId.from_file(client_secrets_path)
        end
        token_store = Google::Auth::Stores::FileTokenStore.new(:file => token_store_path)
        authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

        user_id = options[:user] || 'default'

        credentials = authorizer.get_credentials(user_id)
        if credentials.nil?
          url = authorizer.get_authorization_url(base_url: OOB_URI)
          say "Open the following URL in your browser and authorize the application."
          say url
          code = ask "Enter the authorization code:"
          credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI)
        end
        credentials
      end

      # Gets the API key of the client
      def api_key
        ENV['GOOGLE_API_KEY'] || options[:api_key]
      end

    end
  end

  ####### analytics ########

  class Analytics < BaseCli
    
    require 'uri'

    Analytics = Google::Apis::AnalyticsreportingV4

    desc 'get_location_url', 'Constructs a location URL for GA at a certain date'
    def get_location_url(location, start_date, end_date)
      location_start = location.version_at(start_date) || location
      location_end = location.version_at(end_date || start_date) || location
      
      #p "start_date=#{start_date}"
      #p "end_date=#{end_date}"
      
      #p "location_start=#{location_start.updated_at}, #{location_start.url_name}"
      #p "location_end=#{location_end.updated_at}, #{location_end.url_name}"

      # p "location_start=#{location_start.inspect}"
      # p "location_end=#{location_end.inspect}"

      page_paths = [
        "ga:pagePath==/locations/#{location_start.url_name}",
        "ga:pagePath==/locations/#{location_end.url_name}",
        "ga:pagePath==/locations/#{location_start.url_name.gsub('-', '_')}",
        "ga:pagePath==/locations/#{location_end.url_name.gsub('-', '_')}",
        "ga:pagePath==/locations/#{location_start.state}/#{location_start.city.gsub(',', '\,')}/#{location_start.url_name}",
        "ga:pagePath==/locations/#{location_end.state}/#{location_end.city.gsub(',', '\,')}/#{location_end.url_name}",
        "ga:pagePath==/locations/#{location_start.state}/#{location_start.city.gsub(',', '\,')}/#{location_start.url_name.gsub('-', '_')}",
        "ga:pagePath==/locations/#{location_end.state}/#{location_end.city.gsub(',', '\,')}/#{location_end.url_name.gsub('-', '_')}",
        "ga:pagePath==/locations/#{location_start.state}/#{location_start.city.split(', ')[0]}/#{location_start.url_name}",
        "ga:pagePath==/locations/#{location_end.state}/#{location_end.city.split(', ')[0]}/#{location_end.url_name}",
        "ga:pagePath==/locations/#{location_start.state}/#{location_start.city.split(', ')[0]}/#{location_start.url_name.gsub('-', '_')}",
        "ga:pagePath==/locations/#{location_end.state}/#{location_end.city.split(', ')[0]}/#{location_end.url_name.gsub('-', '_')}",
        "ga:pagePath==/store/#{location_start.url_name}",
        "ga:pagePath==/store/#{location_end.url_name}",
        "ga:pagePath==/store/#{location_start.url_name.gsub('-', '_')}",
        "ga:pagePath==/store/#{location_end.url_name.gsub('-', '_')}",
        "ga:pagePath==/stores/#{location_start.url_name}",
        "ga:pagePath==/stores/#{location_end.url_name}",
        "ga:pagePath==/stores/#{location_start.url_name.gsub('-', '_')}",
        "ga:pagePath==/stores/#{location_end.url_name.gsub('-', '_')}",
      ]

      #p "page_paths.join=#{page_paths.join(',')}"
      

      #{}"ga:pagePath=~/locations/#{location_start.url_name}"

      page_paths.join(',')
    end

    desc 'booknow_data', 'Retrieve BookNow Google Analytics data'
    def booknow_data(profile_id='81802112', start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
      analytics = Analytics::AnalyticsReportingService.new
      analytics.authorization = user_credentials_for(Analytics::AUTH_ANALYTICS)

      data = {
        start_date: start_date,
        end_date: end_date
      }

      # # unique visits - visits, new visitors, returning visitors
      # data[:unique_visits] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:userType', 'ga:screenviews')
      # data[:unique_visits_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:userType', 'ga:screenviews')

      # # time on site, pages/session
      # data[:time_on_page_and_pageviews_per_session] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:appName', 'ga:avgScreenviewDuration ga:screenviewsPerSession')
      # if data[:time_on_page_and_pageviews_per_session] && data[:time_on_page_and_pageviews_per_session].length > 0
      #   data[:time_on_site] = 0.0
      #   data[:pageviews_per_session] = 0.0
      #   data[:time_on_page_and_pageviews_per_session].each do |top_and_pps|
      #     data[:time_on_site] = data[:time_on_site] + top_and_pps[1].to_f
      #     data[:pageviews_per_session] = data[:pageviews_per_session] + top_and_pps[2].to_f
      #   end
      # end

      # data[:time_on_page_and_pageviews_per_session_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:appName', 'ga:avgScreenviewDuration ga:screenviewsPerSession')
      # if data[:time_on_page_and_pageviews_per_session_prev_month] && data[:time_on_page_and_pageviews_per_session_prev_month].length > 0
      #   data[:time_on_site_prev_month] = 0.0
      #   data[:pageviews_per_session_prev_month] = 0.0
      #   data[:time_on_page_and_pageviews_per_session_prev_month].each do |top_and_pps|
      #     data[:time_on_site_prev_month] = data[:time_on_site_prev_month] + top_and_pps[1].to_f
      #     data[:pageviews_per_session_prev_month] = data[:pageviews_per_session_prev_month] + top_and_pps[2].to_f
      #   end
      # end


      data[:overview] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==BookNow')

      results = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==BookNow;ga:eventAction==Results')
      top_results_locations = {}
      top_results_queries = {}
      p "results=#{results}"
      if results && results.length > 0
        results.each do |result|
          begin
            result = eval(result[0])
            if result[:location]
              if top_results_locations.key?(result[:location])
                top_results_locations[result[:location]] = top_results_locations[result[:location]] + 1
              else
                top_results_locations[result[:location]] = 1
              end
            end

            if result[:query]
              if top_results_queries.key?(result[:query])
                top_results_queries[result[:query]] = top_results_queries[result[:query]] + 1
              else
                top_results_queries[result[:query]] = 1
              end
            end
          rescue => e
            p "couldnt eval yo"
          end
        end
        #p "top_results_locations=#{top_results_locations.sort_by{|k, v| !v}}"
        data[:results_locations] = top_results_locations.sort_by{ |k,v| v }.reverse[0..9]
        data[:results_queries] = top_results_queries.sort_by{ |k,v| v }.reverse[0..9]
      end

      booking_completes = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==BookNow;ga:eventAction==Booking Complete')
      top_booking_complete_locations = {}
      p "booking_completes=#{booking_completes}"
      if booking_completes && booking_completes.length > 0
        booking_completes.each do |result|
          begin
            result = eval(result[0])

            if result[:location]
              if top_booking_complete_locations.key?(result[:location])
                top_booking_complete_locations[result[:location]] = top_booking_complete_locations[result[:location]] + 1
              else
                top_booking_complete_locations[result[:location]] = 1
              end
            end
            #p "result=#{result}"
          rescue => e
            p "couldnt eval yo"
          end
        end
        p "top_booking_complete_locations=#{top_booking_complete_locations}"
        data[:booking_complete_locations] = top_booking_complete_locations.sort_by{ |k,v| v }.reverse[0..9]
      end

      open_booking_modals = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==BookNow;ga:eventAction==Open Booking Modal')
      top_open_booking_modal_locations = {}
      p "open_booking_modals=#{open_booking_modals}"
      if open_booking_modals && open_booking_modals.length > 0
        open_booking_modals.each do |result|
          begin
            result = eval(result[0])
            if result[:location]
              if top_open_booking_modal_locations.key?(result[:location])
                top_open_booking_modal_locations[result[:location]] = top_open_booking_modal_locations[result[:location]] + 1
              else
                top_open_booking_modal_locations[result[:location]] = 1
              end
            end
            #p "result=#{result}"
          rescue => e
            p "couldnt eval yo"
          end
        end
        p "top_open_booking_modal_locations=#{top_open_booking_modal_locations}"
        data[:open_booking_modal_locations] = top_open_booking_modal_locations.sort_by{ |k,v| v }.reverse[0..9]
      end

      data
    end

    desc 'location_data', 'Retrieve solasalonstudios.com location Google Analytics data'
    def location_data(profile_id='81802112', location=nil, start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
      analytics = Analytics::AnalyticsReportingService.new
      analytics.authorization = user_credentials_for(Analytics::AUTH_ANALYTICS)

      data = {
        start_date: start_date,
        end_date: end_date,
        location_name: location.name,
        location_url: "/locations/#{location.url_name}"
      }

      # current year pageviews (by month)
      (1..start_date.month).each do |month|
        p "current year pageviews #{month}"
        data_month = get_ga_data(analytics, profile_id, DateTime.new(start_date.year, month, 1).strftime('%F'), DateTime.new(start_date.year, month, 1).end_of_month.strftime('%F'), 'ga:userType', 'ga:pageviews', nil, get_location_url(location, DateTime.new(start_date.year, month, 1), DateTime.new(start_date.year, month, 1).end_of_month))
        key_sym = "pageviews_current_#{month}".to_sym
        data[key_sym] = data_month
        sleep 0.2
      end

      # previous year pageviews (by month)
      (1..12).each do |month|
        p "previous year pageviews #{month}"
        data_month = get_ga_data(analytics, profile_id, DateTime.new((start_date - 1.year).year, month, 1).strftime('%F'), DateTime.new((start_date - 1.year).year, month, 1).end_of_month.strftime('%F'), 'ga:userType', 'ga:pageviews', nil, get_location_url(location, DateTime.new((start_date - 1.year).year, month, 1), DateTime.new((start_date - 1.year).year, month, 1).end_of_month))
        key_sym = "pageviews_last_#{month}".to_sym
        data[key_sym] = data_month
        sleep 0.2
      end

      sleep 1

      p "begin unique visits"
      # unique visits - visits, new visitors, returning visitors
      data[:unique_visits] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:userType', 'ga:pageviews', nil, get_location_url(location, start_date, end_date))
      data[:unique_visits_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:userType', 'ga:pageviews', nil, get_location_url(location, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month))
      data[:unique_visits_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).end_of_month.strftime('%F'), 'ga:userType', 'ga:pageviews', nil, get_location_url(location, (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month))
      p "end unique visits"

      # referrals - source, % of traffic
      # ga:medium
      # ga:acquisitionTrafficChannel
      data[:referrals] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:medium', 'ga:pageviews', '-ga:pageviews', get_location_url(location, start_date, end_date))[0..4]
      p "done with referrals"

      # top referrers - site, visits
      data[:top_referrers] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:source', 'ga:pageviews', '-ga:pageviews', get_location_url(location, start_date, end_date))
      data[:top_referrers] = data[:top_referrers][0..6] if data[:top_referrers]
      p "done with top referrers"

      # # devices - mobile, desktop, mobile % change vs same month a year ago
      # data[:devices] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:deviceCategory', 'ga:pageviews', '-ga:pageviews', get_location_url(location, start_date, end_date))
      # if data[:devices] && data[:devices].length == 3
      #   tablets = data[:devices].pop
      #   data[:devices][1][1] = data[:devices][1][1].to_i + tablets[1].to_i
      # end
      # p "done with devices"

      # data[:devices_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:deviceCategory', 'ga:pageviews', '-ga:pageviews', get_location_url(location, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month))
      # if data[:devices_prev_month] && data[:devices_prev_month].length == 3
      #   tablets = data[:devices_prev_month].pop
      #   data[:devices_prev_month][1][1] = data[:devices_prev_month][1][1].to_i + tablets[1].to_i
      # end
      # p "done with devices prev month"

      # data[:devices_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).end_of_month.strftime('%F'), 'ga:deviceCategory', 'ga:pageviews', '-ga:pageviews', get_location_url(location, (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month))
      # if data[:devices_prev_year] && data[:devices_prev_year].length == 3
      #   tablets = data[:devices_prev_year].pop
      #   data[:devices_prev_year][1][1] = data[:devices_prev_year][1][1].to_i + tablets[1].to_i
      # end
      # p "done with devices prev year"

      # locations - top regions that visited (city, visits)
      data[:top_regions] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:city', 'ga:pageviews', '-ga:pageviews', get_location_url(location, start_date, end_date))
      data[:top_regions] = data[:top_regions][0..6] if data[:top_regions]
      p "done with top regions"

      # time on site, pages/session
      data[:time_on_page_and_pageviews_per_session] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:pagePath', 'ga:avgTimeOnPage ga:pageviewsPerSession', nil, get_location_url(location, start_date, end_date))
      if data[:time_on_page_and_pageviews_per_session] && data[:time_on_page_and_pageviews_per_session].length > 0
        data[:time_on_site] = 0.0
        data[:pageviews_per_session] = 0.0
        data[:pages_with_pageviews] = 0
        data[:time_on_page_and_pageviews_per_session].each do |top_and_pps|
          if top_and_pps[2].to_f > 0
            data[:time_on_site] = data[:time_on_site] + top_and_pps[1].to_f
            data[:pageviews_per_session] = data[:pageviews_per_session] + top_and_pps[2].to_f
            data[:pages_with_pageviews] = data[:pages_with_pageviews] + 1
          end
        end
      end
      p "done with time on site, pages/session"

      # data[:location_phone_number_clicks_current_month] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', "ga:eventCategory==Location Phone Number;ga:eventLabel==#{location.id}")
      # p "data[:location_phone_number_clicks_current_month]=#{data[:location_phone_number_clicks_current_month]}"
      # data[:location_phone_number_clicks_current_month] = data[:location_phone_number_clicks_current_month] ? data[:location_phone_number_clicks_current_month][0][1] : 1
      
      # data[:location_phone_number_clicks_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', "ga:eventCategory==Location Phone Number;ga:eventLabel==#{location.id}")
      # p "data[:location_phone_number_clicks_prev_month]=#{data[:location_phone_number_clicks_prev_month]}"
      # data[:location_phone_number_clicks_prev_month] = data[:location_phone_number_clicks_prev_month] ? data[:location_phone_number_clicks_prev_month][0][1] : 1

      # data[:location_phone_number_clicks_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month, (end_date - 1.year).beginning_of_month, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', "ga:eventCategory==Location Phone Number;ga:eventLabel==#{location.id}")
      # p "data[:location_phone_number_clicks_prev_year]=#{data[:location_phone_number_clicks_prev_year]}"
      # data[:location_phone_number_clicks_prev_year] = data[:location_phone_number_clicks_prev_year] ? data[:location_phone_number_clicks_prev_year][0][1] : 1

      data
    end

    desc 'solapro_web_data', 'Retrieve Sola Pro web Google Analytics data'
    def solapro_web_data(profile_id='105609602', start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
      analytics = Analytics::AnalyticsReportingService.new
      analytics.authorization = user_credentials_for(Analytics::AUTH_ANALYTICS)

      data = {
        start_date: start_date,
        end_date: end_date
      }

      # unique visits - visits, new visitors, returning visitors
      data[:unique_visits] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:userType', 'ga:pageviews')
      data[:unique_visits_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:userType', 'ga:pageviews')

      # time on site, pages/session
      data[:time_on_page_and_pageviews_per_session] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:hostName', 'ga:avgTimeOnPage ga:pageviewsPerSession')
      if data[:time_on_page_and_pageviews_per_session] && data[:time_on_page_and_pageviews_per_session].length > 0
        data[:time_on_site] = 0.0
        data[:pageviews_per_session] = 0.0
        data[:time_on_page_and_pageviews_per_session].each do |top_and_pps|
          data[:time_on_site] = data[:time_on_site] + top_and_pps[1].to_f
          data[:pageviews_per_session] = data[:pageviews_per_session] + top_and_pps[2].to_f
        end
      end
      data[:time_on_page_and_pageviews_per_session_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:hostName', 'ga:avgTimeOnPage ga:pageviewsPerSession')
      if data[:time_on_page_and_pageviews_per_session_prev_month] && data[:time_on_page_and_pageviews_per_session_prev_month].length > 0
        data[:time_on_site_prev_month] = 0.0
        data[:pageviews_per_session_prev_month] = 0.0
        data[:time_on_page_and_pageviews_per_session_prev_month].each do |top_and_pps|
          data[:time_on_site_prev_month] = data[:time_on_site_prev_month] + top_and_pps[1].to_f
          data[:pageviews_per_session_prev_month] = data[:pageviews_per_session_prev_month] + top_and_pps[2].to_f
        end
      end

      # deals viewed
      data[:deals_viewed] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Deal')
      data[:deals_viewed_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Deal')

      # videos viewed
      data[:videos_viewed] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Video')
      data[:videos_viewed_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Video')

      # top deals 
      top_deals = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Deal')
      data[:top_deals] = []
      top_deals.each do |top_deal|
        next if top_deal[0].include?('click') || !top_deal[0].include?('|') || data[:top_deals].length >= 5
        data[:top_deals] << top_deal
      end

      # top tools
      data[:top_tools] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Tools and Resources')[0..4]

      # top videos
      top_videos = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Video')
      data[:top_videos] = []
      top_videos.each do |top_video|
        next if top_video[0].include?('click') || !top_video[0].include?('|') || data[:top_videos].length >= 5
        data[:top_videos] << top_video
      end

      # top brands
      data[:top_brands] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Brand')[0..4]

      data
    end

    desc 'solapro_app_data', 'Retrieve Sola Pro app Google Analytics data'
    def solapro_app_data(profile_id='113771223', start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
      analytics = Analytics::AnalyticsReportingService.new
      analytics.authorization = user_credentials_for(Analytics::AUTH_ANALYTICS)

      data = {
        start_date: start_date,
        end_date: end_date
      }

      # unique visits - visits, new visitors, returning visitors
      data[:unique_visits] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:userType', 'ga:screenviews')
      data[:unique_visits_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:userType', 'ga:screenviews')

      # time on site, pages/session
      data[:time_on_page_and_pageviews_per_session] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:appName', 'ga:avgScreenviewDuration ga:screenviewsPerSession')
      if data[:time_on_page_and_pageviews_per_session] && data[:time_on_page_and_pageviews_per_session].length > 0
        data[:time_on_site] = 0.0
        data[:pageviews_per_session] = 0.0
        data[:time_on_page_and_pageviews_per_session].each do |top_and_pps|
          data[:time_on_site] = data[:time_on_site] + top_and_pps[1].to_f
          data[:pageviews_per_session] = data[:pageviews_per_session] + top_and_pps[2].to_f
        end
      end

      data[:time_on_page_and_pageviews_per_session_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:appName', 'ga:avgScreenviewDuration ga:screenviewsPerSession')
      if data[:time_on_page_and_pageviews_per_session_prev_month] && data[:time_on_page_and_pageviews_per_session_prev_month].length > 0
        data[:time_on_site_prev_month] = 0.0
        data[:pageviews_per_session_prev_month] = 0.0
        data[:time_on_page_and_pageviews_per_session_prev_month].each do |top_and_pps|
          data[:time_on_site_prev_month] = data[:time_on_site_prev_month] + top_and_pps[1].to_f
          data[:pageviews_per_session_prev_month] = data[:pageviews_per_session_prev_month] + top_and_pps[2].to_f
        end
      end

      # deals viewed
      data[:deals_viewed] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Deals')
      data[:deals_viewed_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Deals')

      # videos viewed
      data[:videos_viewed] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Videos')
      data[:videos_viewed_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Videos')

      # top deals 
      data[:top_deals] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Deals')[0..4]

      # top tools
      data[:top_tools] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Tools and Resources')[0..4]

      # top videos
      data[:top_videos] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Videos')[0..4]

      # top brands
      data[:top_brands] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Brands')[0..4]

      data
    end

    desc 'solasalonstudios_data', 'Retrieve solasalonstudios.com Google Analytics data'
    def solasalonstudios_data(profile_id='81802112', start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
      analytics = Analytics::AnalyticsReportingService.new
      analytics.authorization = user_credentials_for(Analytics::AUTH_ANALYTICS)

      data = {
        start_date: start_date,
        end_date: end_date
      }

      # current year pageviews (by month)
      (1..start_date.month).each do |month|
        data_month = get_ga_data(analytics, profile_id, DateTime.new(start_date.year, month, 1).strftime('%F'), DateTime.new(start_date.year, month, 1).end_of_month.strftime('%F'), 'ga:userType', 'ga:pageviews')
        key_sym = "pageviews_current_#{month}".to_sym
        data[key_sym] = data_month
      end

      # previous year pageviews (by month)
      (1..12).each do |month|
        data_month = get_ga_data(analytics, profile_id, DateTime.new((start_date - 1.year).year, month, 1).strftime('%F'), DateTime.new((start_date - 1.year).year, month, 1).end_of_month.strftime('%F'), 'ga:userType', 'ga:pageviews')
        key_sym = "pageviews_last_#{month}".to_sym
        data[key_sym] = data_month
      end

      # unique visits - visits, new visitors, returning visitors
      data[:unique_visits] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:userType', 'ga:pageviews')
      data[:unique_visits_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:userType', 'ga:pageviews')
      data[:unique_visits_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month, 'ga:userType', 'ga:pageviews')

      # referrals - source, % of traffic
      # ga:medium
      data[:referrals] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:acquisitionTrafficChannel', 'ga:pageviews', '-ga:pageviews')[0..4]

      # top referrers - site, visits
      data[:top_referrers] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:source', 'ga:pageviews', '-ga:pageviews')[0..6]

      # devices - mobile, desktop, mobile % change vs same month a year ago
      data[:devices] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:deviceCategory')
      tablets = data[:devices].pop
      data[:devices][1][1] = data[:devices][1][1].to_i + tablets[1].to_i
      
      data[:devices_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:deviceCategory')
      tablets = data[:devices_prev_month].pop
      data[:devices_prev_month][1][1] = data[:devices_prev_month][1][1].to_i + tablets[1].to_i

      data[:devices_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month, 'ga:deviceCategory')
      tablets = data[:devices_prev_year].pop
      data[:devices_prev_year][1][1] = data[:devices_prev_year][1][1].to_i + tablets[1].to_i

      # locations - top regions that visited (city, visits)
      data[:top_regions] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:city', 'ga:pageviews', '-ga:pageviews')[0..6]

      # blogs - url, visits
      data[:blogs] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:pagePath', 'ga:pageviews ga:avgSessionDuration ga:bounceRate', '-ga:pageviews', 'ga:pagePath=~/blog/*')
      data[:blogs][0..9].each_with_index do |blog, idx|
        blog << get_page_title("https://www.solasalonstudios.com#{blog[0]}")
        data[:blogs][idx] = blog
      end
      data[:blogs_page_views] = 0
      data[:blogs_avg_session_duration] = 0.0
      data[:blogs_bounce_rate] = 0.0
      data[:blogs].each do |blog|
        data[:blogs_page_views] = data[:blogs_page_views] + blog[1].to_i
        data[:blogs_avg_session_duration] = data[:blogs_avg_session_duration] + blog[2].to_f
        data[:blogs_bounce_rate] = data[:blogs_bounce_rate] + blog[3].to_f
      end

      # exit pages
      data[:exit_pages] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:exitPagePath', 'ga:exits', '-ga:exits')[0..6]
      data[:exit_pages].each_with_index do |exit_page, idx|
        exit_page << get_page_title("https://www.solasalonstudios.com#{exit_page[0]}")
        data[:exit_pages][idx] = exit_page
      end

      # time on site, pages/session
      data[:time_on_page_and_pageviews_per_session] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:pagePath', 'ga:avgTimeOnPage ga:pageviewsPerSession')
      data[:time_on_site] = 0.0
      data[:pageviews_per_session] = 0.0
      data[:time_on_page_and_pageviews_per_session].each do |top_and_pps|
        data[:time_on_site] = data[:time_on_site] + top_and_pps[1].to_f
        data[:pageviews_per_session] = data[:pageviews_per_session] + top_and_pps[2].to_f
      end

      # contact form submissions
      data[:contact_form_submissions_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?)', start_date, end_date).count
      data[:contact_form_submissions_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?)', start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month).count
      data[:contact_form_submissions_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?)', (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month).count

      # phone number clicks
      data[:location_phone_number_clicks_current_month] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Location Phone Number')[0][1] || 1
      data[:location_phone_number_clicks_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Location Phone Number')[0][1] || 1
      data[:location_phone_number_clicks_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month, (end_date - 1.year).beginning_of_month, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Location Phone Number')
      data[:location_phone_number_clicks_prev_year] = data[:location_phone_number_clicks_prev_year] ? data[:location_phone_number_clicks_prev_year][0][1] : 1

      data[:professional_phone_number_clicks_current_month] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Professional Phone Number')[0][1] || 1
      data[:professional_phone_number_clicks_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Professional Phone Number')[0][1] || 1
      data[:professional_phone_number_clicks_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month, (end_date - 1.year).beginning_of_month, 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Professional Phone Number')
      data[:professional_phone_number_clicks_prev_year] = data[:professional_phone_number_clicks_prev_year] ? data[:professional_phone_number_clicks_prev_year][0][1] : 1

      data
    end

    desc 'get_ga_data, profile_id, start_date, end_date, dimensions, metrics, sort, filters_expression', 'Gets GA data'
    def get_ga_data(analytics=nil, profile_id=nil, start_date=nil, end_date=nil, dimensions=nil, metrics=nil, sort=nil, filters_expression=nil)
      return [] unless analytics && profile_id && start_date && end_date && dimensions

      grr = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new
      rr = Google::Apis::AnalyticsreportingV4::ReportRequest.new
      rr.view_id = profile_id

      #rr.filters_expression ="ga:medium==referral"#ga:pagePath==/about-us"#%w(ga:pagePath==/about-us;ga:browser==Firefox)
      if dimensions
        dimensions_arr = []
        dimensions.split(' ').each do |dimension_str|
          dimension = Google::Apis::AnalyticsreportingV4::Dimension.new
          dimension.name = dimension_str
          dimensions_arr << dimension
        end
        rr.dimensions = dimensions_arr
      end     
      
      if metrics
        metrics_arr = []
        metrics.split(' ').each do |metric_str|
          metric = Google::Apis::AnalyticsreportingV4::Metric.new
          metric.expression = metric_str
          metrics_arr << metric
        end
        rr.metrics = metrics_arr     
      end

      range = Google::Apis::AnalyticsreportingV4::DateRange.new
      range.start_date = start_date
      range.end_date = end_date
      rr.date_ranges = [range]

      if sort
        order_by = Google::Apis::AnalyticsreportingV4::OrderBy.new 
        if sort.start_with? '-'
          sort[0] = ''
          order_by.field_name = sort
          order_by.sort_order = "DESCENDING"
        else
          order_by.field_name = sort
        end
        
        rr.order_bys = [order_by]
      end

      if filters_expression
        #p "filters_expression=#{filters_expression}"
        rr.filters_expression = filters_expression
      end

      grr.report_requests = [rr]

      response = analytics.batch_get_reports(grr)
      #p "dimensions=#{dimensions}"
      #puts response.inspect if dimensions == 'ga:deviceCategory'
      #puts response.reports.inspect if dimensions == 'ga:deviceCategory'

      data = response.reports.map{|report| 
        #p "report.data.rows=#{report.data.rows.inspect}"
        return nil if report.data.rows.nil?
        # p "report.data.rows=#{report.data.rows.inspect}" if dimensions == 'ga:deviceCategory'
        # p "$$$"
        # p "$$$"
        # p "$$$"
        # p "report.data.rows[0]=#{report.data.rows[0].inspect}"
        # p "$$$"
        # p "$$$"
        # p "$$$"
        # p "report.data.rows[1]=#{report.data.rows[1].inspect}"
        return report.data.rows.map{|row|
          #p "row.dimensions=#{row.dimensions.inspect}" if dimensions && dimensions.split(' ').length > 1
          #p "row.metrics=#{row.metrics.inspect}" 
          # if metrics && metrics.split(' ').length > 1
          #   row.metrics.each_with_index do |metrics, idx|
          #     p "row.metrics[#{idx}]=#{row.metrics[idx].values.inspect}"
          #   end
          # end
          #p "row=#{row.inspect}" if dimensions == 'ga:deviceCategory'
          #p "row=#{row.dimensions[0]}, #{row.metrics[0].values[0]}"
          # arr = [];
          # row.dimensions.each_with_index do |dimension|
          #   arr << []
          # end
          #p "row.metrics[0].values.length=#{row.metrics[0].values.length}"
          [row.dimensions[0], *row.metrics[0].values]
        }
      }
      # data = response.reports[0].data.rows.map{|r|
      #   data = r.to_h
      #   p "data=#{data}"
      #   #p "data[:metrics][0]=#{data[:metrics][0]}"
      #   p "data[:metrics][0][:values]=#{data[:metrics][0][:values]}"
      #   return data[:metrics][0][:values]
      # }

      return data
    end

    require 'mechanize'

    desc 'get_page_title, url', 'Retrieves a page title from a URL'
    def get_page_title(url)
      page_title = Mechanize.new.get(url).title
      if page_title.split('-').size > 1
        page_title = page_title[0..(page_title.rindex('-') - 2)].strip
      end
      page_title
    end

  end 

end