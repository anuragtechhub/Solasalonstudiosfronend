# TODO: refactor this piece of shit
module Reports
  class WelcomeJob < ::Reports::ReportJob

    def perform(start_date, end_date)
      start_date = Time.parse(start_date)
      end_date = Time.parse(end_date)
      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      #######
      # EmailEvents
      welcome_email_total_clicks = 0
      welcome_email_clicks = {}
      welcome_email_click_events = EmailEvent.where(category: 'Welcome Email', event: 'click', created_at: start_date..end_date)
      welcome_email_click_events.each do |click_event|
        if welcome_email_clicks.key? click_event[:url]
          welcome_email_clicks[click_event[:url]] = welcome_email_clicks[click_event[:url]] + 1
        else
          welcome_email_clicks[click_event[:url]] = 1
        end
        welcome_email_total_clicks = welcome_email_total_clicks + 1
      end

      welcome_email_bounce_events = EmailEvent.where(:category => 'Welcome Email', :event => 'bounce', :created_at => start_date..end_date)

      resend_welcome_email_total_clicks = 0
      resend_welcome_email_clicks = {}
      resend_welcome_email_click_events = EmailEvent.where(:category => 'Resend Welcome Email', :event => 'click', :created_at => start_date..end_date)
      p "we have #{welcome_email_click_events.size} Welcome Email CLICK events to process"
      resend_welcome_email_click_events.each do |click_event|
        if resend_welcome_email_clicks.key? click_event[:url]
          resend_welcome_email_clicks[click_event[:url]] = resend_welcome_email_clicks[click_event[:url]] + 1
        else
          resend_welcome_email_clicks[click_event[:url]] = 1
        end
        resend_welcome_email_total_clicks = resend_welcome_email_total_clicks + 1
      end

      resend_welcome_email_bounce_events = EmailEvent.where(:category => 'Resend Welcome Email', :event => 'bounce', :created_at => start_date..end_date)

      ##################################################
      # Retrieve all categories #
      # GET /categories #
      # p "Retrieve all categories"

      # params = JSON.parse('{"category": "Welcome Email", "limit": 1, "offset": 1}')
      # response = sg.client.categories.get(query_params: params)
      # puts response.status_code
      # puts response.body
      # puts response.headers

      ##################################################
      # Retrieve Email Statistics for Categories #
      # GET /categories/stats #
      # p "Retrieve Email Statistics for Categories"

      # params = {end_date: end_date.strftime('%F'), aggregated_by: "day", limit: 1, offset: 1, start_date: start_date.strftime('%F'), categories: "Welcome Email"}
      # response = sg.client.categories.stats.get(query_params: params)
      # puts response.status_code
      # puts response.body
      # puts response.headers

      ##################################################
      # Retrieve sums of email stats for each category [Needs: Stats object defined, has category ID?] #
      # GET /categories/stats/sums #

      welcome_email_metrics = {
        "blocks" => 0,
        "bounces" => 0,
        "clicks" => 0,
        "delivered" => 0,
        "unique_opens" => 0,
        "spam_reports" => 0,
      }

      params = {categories: "Welcome Email", end_date: end_date.strftime('%F'), aggregated_by: "day", limit: 1, offset: 1, start_date: start_date.strftime('%F'), sort_by_direction: "asc"}
      response = sg.client.categories.stats.get(query_params: params)

      welcome_email_data_rows = nil
      if response.status_code.to_i == 200
        welcome_email_data_rows = JSON.parse(response.body)
        # calculate totals
        welcome_email_data_rows.each do |data_row|
          row_metrics = data_row['stats'].first['metrics']
          welcome_email_metrics['blocks'] += row_metrics['blocks']
          welcome_email_metrics['bounces'] += row_metrics['bounces']
          welcome_email_metrics['clicks'] += row_metrics['clicks']
          welcome_email_metrics['delivered'] += row_metrics['delivered']
          welcome_email_metrics['unique_opens'] += row_metrics['unique_opens']
          welcome_email_metrics['spam_reports'] += row_metrics['spam_reports']
        end
      else
        p "NOT A 200 response, status_code=#{response.status_code}"
      end

      ##################################################
      # Retrieve sums of email stats for each category [Needs: Stats object defined, has category ID?] #
      # GET /categories/stats/sums #
      p "Retrieve sums of email stats for each category"

      resend_welcome_email_metrics = {
        "blocks" => 0,
        "bounces" => 0,
        "clicks" => 0,
        "delivered" => 0,
        "unique_opens" => 0,
        "spam_reports" => 0,
      }

      params = {categories: "Resend Welcome Email", end_date: end_date.strftime('%F'), aggregated_by: "day", limit: 1, offset: 1, start_date: start_date.strftime('%F'), sort_by_direction: "asc"}
      response = sg.client.categories.stats.get(query_params: params)

      resend_welcome_email_data_rows = nil
      if response.status_code.to_i == 200
        resend_welcome_email_data_rows = JSON.parse(response.body)

        # calculate totals
        resend_welcome_email_data_rows.each do |data_row|
          row_metrics = data_row['stats'].first['metrics']
          resend_welcome_email_metrics['blocks'] += row_metrics['blocks']
          resend_welcome_email_metrics['bounces'] += row_metrics['bounces']
          resend_welcome_email_metrics['clicks'] += row_metrics['clicks']
          resend_welcome_email_metrics['delivered'] += row_metrics['delivered']
          resend_welcome_email_metrics['unique_opens'] += row_metrics['unique_opens']
          resend_welcome_email_metrics['spam_reports'] += row_metrics['spam_reports']
        end
      else
        p "NOT A 200 response, status_code=#{response.status_code}"
      end

      locals = {
        data: {
          start_date: start_date,
          end_date: end_date,
          resend_welcome_email_data_rows: resend_welcome_email_data_rows,
          resend_welcome_email_metrics: resend_welcome_email_metrics,
          welcome_email_data_rows: welcome_email_data_rows,
          welcome_email_metrics: welcome_email_metrics,
          welcome_email_clicks: welcome_email_clicks,
          welcome_email_bounce_events: welcome_email_bounce_events,
          resend_welcome_email_clicks: resend_welcome_email_clicks,
          resend_welcome_email_bounce_events: resend_welcome_email_bounce_events,
          welcome_email_total_clicks: welcome_email_total_clicks,
          resend_welcome_email_total_clicks: resend_welcome_email_total_clicks,
        }
      }

      html_renderer = HTMLRenderer.new
      pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/welcome_email', locals))
      ReportsMailer.welcome_email_report(pdf).deliver
    end

  end
end
