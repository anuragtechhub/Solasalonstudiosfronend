namespace :reports do

  require 'google/apis/analyticsreporting_v4'
  require 'render_anywhere'

  task :pdf => :environment do
    html_renderer = HTMLRenderer.new

    locals = {
      :@name => 'Jeff'
    }

    p "pdf! #{html_renderer.build_html(locals)}"
    pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/test', locals), :footer => {:center => '[page]', :font_size => 7})

    save_path = Rails.root.join('pdfs','report.pdf')
    File.open(save_path, 'wb') do |file|
      file << pdf
    end    
  end

  # rake reports:solasalonstudios
  # rake reports:solasalonstudios[2017-01-01]
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

    #p "got data #{locals.inspect}"
    p "got data..."

    html_renderer = HTMLRenderer.new

    p "let's render PDF"
    pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/solasalonstudios', locals), :footer => {:center => '[page]', :font_size => 7})
    p "pdf rendered..."
    save_path = Rails.root.join('pdfs','solasalonstudios.pdf')
    File.open(save_path, 'wb') do |file|
      file << pdf
    end   
    p "file saved" 
  end

  task :show_visits => :environment do
    analytics = Analytics.new
    analytics.show_visits('81802112', '2017-03-01', '2017-04-01')
  end

  task :show_pageviews => :environment do
    analytics = Analytics.new
    analytics.show_pageviews('81802112', '2017-03-01', '2017-04-01')
  end

  task :locations => :environment do
    p "begin locations report..."
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
    Analytics = Google::Apis::AnalyticsreportingV4

    desc 'show_visits PROFILE_ID', 'Show visists for the given analytics profile ID'
    method_option :start, type: :string, required: true
    method_option :end, type: :string, required: true
    
    def show_visits(profile_id, start_date, end_date)
      analytics = Analytics::AnalyticsReportingService.new
      analytics.authorization = user_credentials_for(Analytics::AUTH_ANALYTICS)

      dimensions = %w(ga:date)
      metrics = %w(ga:sessions ga:users ga:newUsers ga:percentNewSessions
                   ga:sessionDuration ga:avgSessionDuration)
      sort = %w(ga:date)
      result = analytics.get_ga_data("ga:#{profile_id}",
                                     start_date,
                                     end_date,
                                     metrics.join(','),
                                     dimensions: dimensions.join(','),
                                     sort: sort.join(','))

      data = []
      data.push(result.column_headers.map { |h| h.name })
      data.push(*result.rows)
      print_table(data)
    end

    desc 'solasalonstudios_data', 'Retrieve solasalonstudios.com Google Analytics data'
    def solasalonstudios_data(profile_id='81802112', start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
      analytics = Analytics::AnalyticsReportingService.new
      analytics.authorization = user_credentials_for(Analytics::AUTH_ANALYTICS)

      data = {
        start_date: start_date,
        end_date: end_date
      }

      # current year pageviews (by month) - visits, unique visits, new visitors, returning visitors, mobile traffic, desktop traffic

      # previous year pageviews (by month) - visits, unique visits, new visitors, returning visitors, mobile traffic, desktop traffic

      # unique visits - visits, new visitors, returning visitors
      data[:unique_visits] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:userType', 'ga:sessions')
      data[:unique_visits_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:userType', 'ga:sessions')

      # referrals - source, % of traffic
      data[:referrals] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:medium', 'ga:pageviews', '-ga:pageviews')[0..6]

      # top referrers - site, visits
      data[:top_referrers] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:source', 'ga:pageviews', '-ga:pageviews')[0..6]

      # devices - mobile, desktop, mobile % change vs same month a year ago
      data[:devices] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:deviceCategory')
      tablets = data[:devices].pop
      data[:devices][1][1] = data[:devices][1][1].to_i + tablets[1].to_i
      data[:devices_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'ga:deviceCategory')
      tablets = data[:devices_prev_month].pop
      data[:devices_prev_month][1][1] = data[:devices_prev_month][1][1].to_i + tablets[1].to_i

      # locations - top regions that visited (city, visits)
      data[:top_regions] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:city', 'ga:pageviews', '-ga:pageviews')[0..6]

      # blogs - url, visits
      data[:blogs] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:pagePath', 'ga:pageviews', '-ga:pageviews', 'ga:pagePath=/blog/*')
      p "data[:blogs]=#{data[:blogs].inspect}"

      # exit pages
      data[:exit_pages] = get_ga_data(analytics, profile_id, start_date, end_date, 'ga:exitPagePath', 'ga:exits', '-ga:exits')[0..6]
      data[:exit_pages].each_with_index do |exit_page, idx|
        exit_page << get_page_title("https://www.solasalonstudios.com#{exit_page[0]}")
        data[:exit_pages][idx] = exit_page
      end


      # time on site + avg pages per visit
      # dimensions = %w(ga:pageTitle ga:sessionDurationBucket)
      # metrics = %w(ga:pageviewsPerSession ga:sessions ga:sessionDuration)
      # sort = %w(-ga:pageTitle)
      # filters = ''#"ga:pagePath==/about-us"#%w(ga:pagePath==/about-us;ga:browser==Firefox)
      # result = analytics.get_ga_data("ga:#{profile_id}",
      #                                start_date.strftime('%F'),
      #                                end_date.strftime('%F'),
      #                                metrics.join(','),
      #                                dimensions: dimensions.join(','),
      #                                #filters: filters,
      #                                sort: sort.join(','))
      # data[:time_on_site] = []
      # data[:time_on_site].push(result.column_headers.map { |h| h.name })
      # data[:time_on_site].push(*result.rows)

      # print_table data[:time_on_site]

      data
    end

    desc 'get_ga_data, profile_id, start_date, end_date, dimensions, metrics, sort, filters', 'Gets GA data'
    def get_ga_data(analytics=nil, profile_id=nil, start_date=nil, end_date=nil, dimensions=nil, metrics=nil, sort=nil, dimension_filter=nil)
      return [] unless analytics && profile_id && start_date && end_date && dimensions

      grr = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new
      rr = Google::Apis::AnalyticsreportingV4::ReportRequest.new
      rr.view_id = profile_id

      #rr.filters_expression ="ga:medium==referral"#ga:pagePath==/about-us"#%w(ga:pagePath==/about-us;ga:browser==Firefox)

      dimension = Google::Apis::AnalyticsreportingV4::Dimension.new
      dimension.name = dimensions
      rr.dimensions = [dimension]      
      
      if metrics
        metric = Google::Apis::AnalyticsreportingV4::Metric.new
        metric.expression = metrics
        rr.metrics = [metric]      
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

      if dimension_filter
        d_filter = Google::Apis::AnalyticsreportingV4::DimensionFilter.new
        d_filter.dimension_name = dimension_filter.split('=')[0]
        d_filter.expressions = [dimension_filter.split('=')[1]]
        rr.dimension_filters = [dimension_filter]
      end

      grr.report_requests = [rr]

      response = analytics.batch_get_reports(grr)
      #p "dimensions=#{dimensions}"
      #puts response.inspect if dimensions == 'ga:deviceCategory'
      #puts response.reports.inspect if dimensions == 'ga:deviceCategory'

      

      data = response.reports.map{|report| 
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
          #p "row=#{row.inspect}" if dimensions == 'ga:deviceCategory'
          #p "row=#{row.dimensions[0]}, #{row.metrics[0].values[0]}"
          [row.dimensions[0], row.metrics[0].values[0]]
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
        page_title = page_title.split('-')[0].strip
      end
      page_title
    end

    desc 'show_pageviews, profile_id, start_date, end_date', 'Show pageviews'
    def show_pageviews(profile_id, start_date, end_date)
      analytics = Analytics::AnalyticsService.new
      analytics.authorization = user_credentials_for(Analytics::AUTH_ANALYTICS)

      dimensions = %w(ga:pagePath ga:socialNetwork)
      metrics = %w(ga:pageviews ga:avgTimeOnPage)
      sort = %w(ga:pagePath)
      filters = "ga:pagePath==/about-us"#%w(ga:pagePath==/about-us;ga:browser==Firefox)
      result = analytics.get_ga_data("ga:#{profile_id}",
                                     start_date,
                                     end_date,
                                     metrics.join(','),
                                     dimensions: dimensions.join(','),
                                     filters: filters,
                                     sort: sort.join(','))

      data = []
      data.push(result.column_headers.map { |h| h.name })
      data.push(*result.rows)
      print_table(data)
    end

    desc 'show_realtime_visits PROFILE_ID', 'Show realtime visists for the given analytics profile ID'
    def show_realtime_visits(profile_id)
      analytics = Analytics::AnalyticsService.new
      analytics.authorization = user_credentials_for(Analytics::AUTH_ANALYTICS)

      dimensions = %w(rt:medium rt:pagePath)
      metrics = %w(rt:activeUsers)
      sort = %w(rt:medium rt:pagePath)
      result = analytics.get_realtime_data("ga:#{profile_id}",
                                           metrics.join(','),
                                           dimensions: dimensions.join(','),
                                           sort: sort.join(','))

      data = []
      data.push(result.column_headers.map { |h| h.name })
      data.push(*result.rows)
      print_table(data)
    end
  end 

end