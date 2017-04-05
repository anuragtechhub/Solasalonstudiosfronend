namespace :reports do

  require 'google/apis/analytics_v3'

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
    Analytics = Google::Apis::AnalyticsV3

    desc 'show_visits PROFILE_ID', 'Show visists for the given analytics profile ID'
    method_option :start, type: :string, required: true
    method_option :end, type: :string, required: true
    
    def show_visits(profile_id, start_date, end_date)
      analytics = Analytics::AnalyticsService.new
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

    def show_pageviews(profile_id, start_date, end_date)
      analytics = Analytics::AnalyticsService.new
      analytics.authorization = user_credentials_for(Analytics::AUTH_ANALYTICS)

      dimensions = %w(ga:pagePath)
      metrics = %w(ga:pageviews ga:avgTimeOnPage)
      sort = %w(ga:pagePath)
      filters = %w(ga:pagePath==/about-us)
      result = analytics.get_ga_data("ga:#{profile_id}",
                                     start_date,
                                     end_date,
                                     metrics.join(','),
                                     dimensions: dimensions.join(','),
                                     filters: filters.join(','),
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