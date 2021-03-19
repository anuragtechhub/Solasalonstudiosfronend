# TODO: refactor this piece of shit
####### analytics ########

class Analytics < BaseCli

  require 'uri'

  def get_location_url(location, start_date, end_date)
    location_start = location.version_at(start_date) || location
    location_end = location.version_at(end_date || start_date) || location

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

    page_paths.join(',')
  end

  def booking_complete_data(profile_id='81802112', start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    analytics.authorization = user_credentials_for(Google::Apis::AnalyticsreportingV4::AUTH_ANALYTICS)

    data = {
      start_date: start_date,
      end_date: end_date
    }

    require 'json'

    booking_data = []

    (start_date.to_date..end_date.to_date).each do |date|
      sleep 0.5
      p "done slept"
      booking_completes = get_ga_data(analytics, profile_id, date, date, 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==BookNow;ga:eventAction==Booking Complete')
      p "booking_completes! #{date}"#, data=#{booking_completes.inspect}"
      if booking_completes && booking_completes.length > 0
        booking_completes.each do |booking_complete|
          next if booking_complete[0] == 'Booking Complete'
          booking_complete_data = JSON.parse(booking_complete[0])
          booking_complete_data["booking_date"] = date
          booking_data << booking_complete_data
        end
      end
    end

    data[:booking_completes] = booking_data.sort_by {|k| k["booking_date"] }
    data[:bookings_total] = data[:booking_completes].length
    total_revenue = 0.0
    data[:booking_completes].each do |booking_complete|
      if booking_complete && booking_complete["total"]
        p "total=#{booking_complete["total"][1..-1].to_f}"
        total_revenue += booking_complete["total"][1..-1].to_f
      end
    end
    data[:bookings_revenue] = total_revenue

    return data
  end

  def booknow_data(profile_id='81802112', start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    analytics.authorization = user_credentials_for(Google::Apis::AnalyticsreportingV4::AUTH_ANALYTICS)

    data = {
      start_date: start_date,
      end_date: end_date
    }

    data[:overview] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==BookNow')

    results = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==BookNow;ga:eventAction==Results')
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
      data[:results_locations] = top_results_locations.sort_by{ |k,v| v }.reverse[0..9]
      data[:results_queries] = top_results_queries.sort_by{ |k,v| v }.reverse[0..9]
    end

    booking_completes = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==BookNow;ga:eventAction==Booking Complete')
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
        rescue => e
          p "couldnt eval yo"
        end
      end
      p "top_booking_complete_locations=#{top_booking_complete_locations}"
      data[:booking_complete_locations] = top_booking_complete_locations.sort_by{ |k,v| v }.reverse[0..9]
    end

    open_booking_modals = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==BookNow;ga:eventAction==Open Booking Modal')
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
        rescue => e
          p "couldnt eval yo"
        end
      end
      p "top_open_booking_modal_locations=#{top_open_booking_modal_locations}"
      data[:open_booking_modal_locations] = top_open_booking_modal_locations.sort_by{ |k,v| v }.reverse[0..9]
    end

    data
  end

  def location_data(profile_id='81802112', location=nil, start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    analytics.authorization = user_credentials_for(Google::Apis::AnalyticsreportingV4::AUTH_ANALYTICS)

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

    p "begin unique pageviews"
    # unique visits - visits, new visitors, returning visitors
    data[:unique_pageviews] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:userType', 'ga:pageviews', nil, get_location_url(location, start_date, end_date))
    data[:unique_pageviews_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:userType', 'ga:pageviews', nil, get_location_url(location, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month))
    data[:unique_pageviews_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).end_of_month.strftime('%F'), 'ga:userType', 'ga:pageviews', nil, get_location_url(location, (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month))
    p "end unique pageviews"
    p "data[:unique_pageviews]=#{data[:unique_pageviews]}"
    p "data[:unique_pageviews_prev_month]=#{data[:unique_pageviews_prev_month]}"
    p "data[:unique_pageviews_prev_year]=#{data[:unique_pageviews_prev_year]}"

    p "begin unique visits"
    # unique visits - visits, new visitors, returning visitors
    data[:unique_visits] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:userType', 'ga:sessions', nil, get_location_url(location, start_date, end_date))
    data[:unique_visits_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:userType', 'ga:sessions', nil, get_location_url(location, start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month))
    data[:unique_visits_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).end_of_month.strftime('%F'), 'ga:userType', 'ga:sessions', nil, get_location_url(location, (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month))
    p "end unique visits"

    # referrals - source, % of traffic
    # ga:medium
    # ga:acquisitionTrafficChannel
    data[:referrals] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:medium', 'ga:pageviews', '-ga:pageviews', get_location_url(location, start_date, end_date))
    data[:referrals] = data[:referrals][0..4] if data[:referrals]
    p "done with referrals"

    # top referrers - site, visits
    data[:top_referrers] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:source', 'ga:pageviews', '-ga:pageviews', get_location_url(location, start_date, end_date))
    data[:top_referrers] = data[:top_referrers][0..6] if data[:top_referrers]
    p "done with top referrers"

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

    # location phone number clicks

    data[:location_phone_number_clicks_current_month] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', "ga:eventCategory==Location Phone Number;ga:eventLabel==#{location.id}")
    #p "data[:location_phone_number_clicks_current_month]=#{data[:location_phone_number_clicks_current_month]}"
    data[:location_phone_number_clicks_current_month] = data[:location_phone_number_clicks_current_month] && data[:location_phone_number_clicks_current_month][0] ? data[:location_phone_number_clicks_current_month][0][1] : 0

    data[:location_phone_number_clicks_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', "ga:eventCategory==Location Phone Number;ga:eventLabel==#{location.id}")
    #p "data[:location_phone_number_clicks_prev_month]=#{data[:location_phone_number_clicks_prev_month]}"
    data[:location_phone_number_clicks_prev_month] = data[:location_phone_number_clicks_prev_month] && data[:location_phone_number_clicks_prev_month][0] ? data[:location_phone_number_clicks_prev_month][0][1] : 0

    data[:location_phone_number_clicks_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).beginning_of_month.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', "ga:eventCategory==Location Phone Number;ga:eventLabel==#{location.id}")
    #p "data[:location_phone_number_clicks_prev_year]=#{data[:location_phone_number_clicks_prev_year]}"
    data[:location_phone_number_clicks_prev_year] = data[:location_phone_number_clicks_prev_year] && data[:location_phone_number_clicks_prev_year][0] ? data[:location_phone_number_clicks_prev_year][0][1] : 0

    stylist_phone_number_filters = get_stylist_stylist_phone_number_filters_for_location(location)
    #p "stylist_phone_number_filters=#{stylist_phone_number_filters}"

    if stylist_phone_number_filters.present?
      data[:professional_phone_number_clicks_current_month] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', "ga:eventCategory==Professional Phone Number;#{stylist_phone_number_filters}")
      data[:professional_phone_number_clicks_current_month] = data[:professional_phone_number_clicks_current_month] && data[:professional_phone_number_clicks_current_month][0] ? data[:professional_phone_number_clicks_current_month][0][1] : 0

      data[:professional_phone_number_clicks_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', "ga:eventCategory==Professional Phone Number;#{stylist_phone_number_filters}")
      data[:professional_phone_number_clicks_prev_month] = data[:professional_phone_number_clicks_prev_month] && data[:professional_phone_number_clicks_prev_month][0] ? data[:professional_phone_number_clicks_prev_month][0][1] : 0

      data[:professional_phone_number_clicks_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).beginning_of_month.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', "ga:eventCategory==Professional Phone Number;#{stylist_phone_number_filters}")
      data[:professional_phone_number_clicks_prev_year] = data[:professional_phone_number_clicks_prev_year] && data[:professional_phone_number_clicks_prev_year][0] ? data[:professional_phone_number_clicks_prev_year][0][1] : 0
    else
      data[:professional_phone_number_clicks_current_month] = 0
      data[:professional_phone_number_clicks_prev_month] = 0
      data[:professional_phone_number_clicks_prev_year] = 0
    end

    data
  end

  def get_stylist_stylist_phone_number_filters_for_location(location)
    filters = []
    location.stylists.each do |stylist|
      filters << "ga:eventLabel==#{stylist.id}"
    end
    return filters.join(',')
  end

  def solapro_web_data(profile_id='105609602', start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    analytics.authorization = user_credentials_for(Google::Apis::AnalyticsreportingV4::AUTH_ANALYTICS)

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

  def solapro_app_data(profile_id='257267659', start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    analytics.authorization = user_credentials_for(Google::Apis::AnalyticsreportingV4::AUTH_ANALYTICS)

    data = {
      start_date: start_date,
      end_date: end_date
    }

    # unique visits - visits, new visitors, returning visitors
    data[:unique_visits] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:userType', 'ga:screenviews')
    data[:unique_visits_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:userType', 'ga:screenviews')

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

    data[:time_on_page_and_pageviews_per_session_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:appName', 'ga:avgScreenviewDuration ga:screenviewsPerSession')
    if data[:time_on_page_and_pageviews_per_session_prev_month] && data[:time_on_page_and_pageviews_per_session_prev_month].length > 0
      data[:time_on_site_prev_month] = 0.0
      data[:pageviews_per_session_prev_month] = 0.0
      data[:time_on_page_and_pageviews_per_session_prev_month].each do |top_and_pps|
        data[:time_on_site_prev_month] = data[:time_on_site_prev_month] + top_and_pps[1].to_f
        data[:pageviews_per_session_prev_month] = data[:pageviews_per_session_prev_month] + top_and_pps[2].to_f
      end
    end

    # deals viewed
    data[:deals_viewed] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Deals')
    data[:deals_viewed_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Deals')

    # videos viewed
    data[:videos_viewed] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Videos')
    data[:videos_viewed_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:eventCategory', 'ga:totalEvents', nil, 'ga:eventCategory==Videos')

    # top deals
    data[:top_deals] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Deals')[0..4]

    # top tools
    data[:top_tools] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Tools and Resources')[0..4]

    # top videos
    data[:top_videos] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventLabel', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Videos')[0..4]

    # top brands
    data[:top_brands] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Brands')[0..4]

    data
  end

  def solasalonstudios_data(profile_id='81802112', start_date=Date.today.beginning_of_month, end_date=Date.today.end_of_month, url="solasalonstudios.com")
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    analytics.authorization = user_credentials_for(Google::Apis::AnalyticsreportingV4::AUTH_ANALYTICS)

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

    # unique pageviews - visits, new visitors, returning visitors
    data[:unique_pageviews] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:userType', 'ga:pageviews')
    data[:unique_pageviews_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:userType', 'ga:pageviews')
    data[:unique_pageviews_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).end_of_month.strftime('%F'), 'ga:userType', 'ga:pageviews')

    # unique visits - visits, new visitors, returning visitors
    data[:unique_visits] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:userType', 'ga:sessions')
    data[:unique_visits_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:userType', 'ga:sessions')
    data[:unique_visits_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).end_of_month.strftime('%F'), 'ga:userType', 'ga:sessions')


    # referrals - source, % of traffic
    # ga:medium
    data[:referrals] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:acquisitionTrafficChannel', 'ga:pageviews', '-ga:pageviews')[0..4]

    # top referrers - site, visits
    data[:top_referrers] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:source', 'ga:pageviews', '-ga:pageviews')[0..6]

    # devices - mobile, desktop, mobile % change vs same month a year ago
    data[:devices] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:deviceCategory')
    tablets = data[:devices].pop
    data[:devices][1][1] = data[:devices][1][1].to_i + tablets[1].to_i

    data[:devices_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.end_of_day.strftime('%F'), 'ga:deviceCategory')
    tablets = data[:devices_prev_month].pop
    data[:devices_prev_month][1][1] = data[:devices_prev_month][1][1].to_i + tablets[1].to_i

    data[:devices_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).end_of_month.end_of_day.strftime('%F'), 'ga:deviceCategory')
    tablets = data[:devices_prev_year].pop
    data[:devices_prev_year][1][1] = data[:devices_prev_year][1][1].to_i + tablets[1].to_i

    # locations - top regions that visited (city, visits)
    data[:top_regions] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:city', 'ga:pageviews', '-ga:pageviews')[0..6]

    # blogs - url, visits
    data[:blogs] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:pagePath', 'ga:pageviews ga:avgSessionDuration ga:bounceRate', '-ga:pageviews', 'ga:pagePath=~/blog/*')
    data[:blogs][0..9].each_with_index do |blog, idx|
      blog << get_page_title("https://www.#{url}#{blog[0]}")
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
    data[:exit_pages] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:exitPagePath', 'ga:exits', '-ga:exits')[0..6]
    data[:exit_pages].each_with_index do |exit_page, idx|
      exit_page << get_page_title("https://www.#{url}#{exit_page[0]}")
      data[:exit_pages][idx] = exit_page
    end

    # time on site, pages/session
    data[:time_on_page_and_pageviews_per_session] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:pagePath', 'ga:avgTimeOnPage ga:pageviewsPerSession')
    data[:time_on_site] = 0.0
    data[:pageviews_per_session] = 0.0
    data[:time_on_page_and_pageviews_per_session].each do |top_and_pps|
      data[:time_on_site] = data[:time_on_site] + top_and_pps[1].to_f
      data[:pageviews_per_session] = data[:pageviews_per_session] + top_and_pps[2].to_f
    end

    if url == 'solasalonstudios.com'
      # leasing form submissions
      data[:leasing_form_submissions_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ?', start_date, end_date, 'Request leasing information').count
      data[:leasing_form_submissions_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ?', start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'Request leasing information').count
      data[:leasing_form_submissions_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ?', (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month, 'Request leasing information').count

      # book an appointment form submissions
      data[:book_an_appointment_inquiries_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ?', start_date, end_date, 'Book an appointment with a salon professional').count
      data[:book_an_appointment_inquiries_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ?', start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'Book an appointment with a salon professional').count
      data[:book_an_appointment_inquiries_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ?', (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month, 'Book an appointment with a salon professional').count

      # other form submissions
      data[:other_form_submissions_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND (how_can_we_help_you = ? OR how_can_we_help_you IS NULL)', start_date, end_date, 'Other').count
      data[:other_form_submissions_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND (how_can_we_help_you = ? OR how_can_we_help_you IS NULL)', start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'Other').count
      data[:other_form_submissions_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND (how_can_we_help_you = ? OR how_can_we_help_you IS NULL)', (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month, 'Other').count
    elsif url == 'solasalonstudios.ca'
      canadian_location_ids = Location.where(:country => 'CA').map(&:id)
      # leasing form submissions
      data[:leasing_form_submissions_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ? AND location_id IN (?)', start_date, end_date, 'Request leasing information', canadian_location_ids).count
      data[:leasing_form_submissions_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ? AND location_id IN (?)', start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'Request leasing information', canadian_location_ids).count
      data[:leasing_form_submissions_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ? AND location_id IN (?)', (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month, 'Request leasing information', canadian_location_ids).count

      # book an appointment form submissions
      data[:book_an_appointment_inquiries_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ? AND location_id IN (?)', start_date, end_date, 'Book an appointment with a salon professional', canadian_location_ids).count
      data[:book_an_appointment_inquiries_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ? AND location_id IN (?)', start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'Book an appointment with a salon professional', canadian_location_ids).count
      data[:book_an_appointment_inquiries_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND how_can_we_help_you = ? AND location_id IN (?)', (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month, 'Book an appointment with a salon professional', canadian_location_ids).count

      # other form submissions
      data[:other_form_submissions_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND (how_can_we_help_you = ? OR how_can_we_help_you IS NULL) AND location_id IN (?)', start_date, end_date, 'Other', canadian_location_ids).count
      data[:other_form_submissions_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND (how_can_we_help_you = ? OR how_can_we_help_you IS NULL) AND location_id IN (?)', start_date.prev_month.beginning_of_month, end_date.prev_month.end_of_month, 'Other', canadian_location_ids).count
      data[:other_form_submissions_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ?) AND (how_can_we_help_you = ? OR how_can_we_help_you IS NULL) AND location_id IN (?)', (start_date - 1.year).beginning_of_month, (end_date - 1.year).end_of_month, 'Other', canadian_location_ids).count
    end

    data[:total_form_submissions_current_month] = data[:other_form_submissions_current_month] + data[:book_an_appointment_inquiries_current_month] + data[:leasing_form_submissions_current_month]
    data[:total_form_submissions_prev_month] = data[:other_form_submissions_prev_month] + data[:book_an_appointment_inquiries_prev_month] + data[:leasing_form_submissions_prev_month]
    data[:total_form_submissions_prev_year] = data[:other_form_submissions_prev_year] + data[:book_an_appointment_inquiries_prev_year] + data[:leasing_form_submissions_prev_year]

    # phone number clicks
    data[:location_phone_number_clicks_current_month] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Location Phone Number').to_a[0].to_a[1] || 0
    data[:location_phone_number_clicks_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Location Phone Number').to_a[0].to_a[1] || 0
    data[:location_phone_number_clicks_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).beginning_of_month.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Location Phone Number')
    data[:location_phone_number_clicks_prev_year] = data[:location_phone_number_clicks_prev_year] ? data[:location_phone_number_clicks_prev_year][0][1] : 0

    data[:professional_phone_number_clicks_current_month] = get_ga_data(analytics, profile_id, start_date.strftime('%F'), end_date.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Professional Phone Number').to_a[0].to_a[1] || 0
    data[:professional_phone_number_clicks_prev_month] = get_ga_data(analytics, profile_id, start_date.prev_month.beginning_of_month.strftime('%F'), end_date.prev_month.end_of_month.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Professional Phone Number').to_a[0].to_a[1] || 0
    data[:professional_phone_number_clicks_prev_year] = get_ga_data(analytics, profile_id, (start_date - 1.year).beginning_of_month.strftime('%F'), (end_date - 1.year).beginning_of_month.strftime('%F'), 'ga:eventAction', 'ga:totalEvents', '-ga:totalEvents', 'ga:eventCategory==Professional Phone Number')
    data[:professional_phone_number_clicks_prev_year] = data[:professional_phone_number_clicks_prev_year] ? data[:professional_phone_number_clicks_prev_year][0][1] : 0

    data
  end

  def get_ga_data(analytics=nil, profile_id=nil, start_date=nil, end_date=nil, dimensions=nil, metrics=nil, sort=nil, filters_expression=nil)
    return [] unless analytics && profile_id && start_date && end_date && dimensions

    grr = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new
    rr = Google::Apis::AnalyticsreportingV4::ReportRequest.new
    rr.view_id = profile_id

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
      rr.filters_expression = filters_expression
    end

    grr.report_requests = [rr]

    response = analytics.batch_get_reports(grr)

    data = response.reports.map{|report|
      return nil if report.data.rows.nil?
      return report.data.rows.map{|row|
        [row.dimensions[0], *row.metrics[0].values]
      }
    }

    return data
  end

  require 'mechanize'

  desc 'get_page_title, url', 'Retrieves a page title from a URL'
  def get_page_title(url)
    if url.index('contact-form-success')
      url = url[0...url.index('contact-form-success')]
    end

    page_title = Mechanize.new.get(url).title
    if page_title.split('-').size > 1
      page_title = page_title[0..(page_title.rindex('-') - 2)].strip
    end
    page_title
  end

end
