namespace :email do

	task :resend_welcome_email => :environment do |task, args|
		p "Begin :resend_welcome_email task..."

		a_week_ago = Date.today - 7.days
		p "a_week_ago=#{a_week_ago.inspect}"

		stylists = Stylist.where(:created_at => a_week_ago.beginning_of_day..a_week_ago.end_of_day)
		p "found #{stylists.size} stylists created a week ago today"

		stylists.each do |stylist|
			p "stylist=#{stylist.inspect}"
			ee = EmailEvent.where(:email => stylist.email_address, :category => 'Welcome Email', :event => 'open')
			if ee.length > 0
				p "this stylist has already opened the welcome email"
			else
				p "this stylist has NOT already opened the welcome email --- resend welcome email!"
				stylist.resend_welcome_email
			end
		end
	end

  # rake email:welcome_report
  # rake email:welcome_report[2018-06-01]
  task :welcome_report, [:start_date] => :environment do |task, args|
  	p "Begin Welcome Email Report..."

  	#if Time.now.day == 2
  		#p "yes its the second day, proceed"
	    start_date = args.start_date.present? ? Date.parse(args.start_date).beginning_of_month : DateTime.now.prev_month.beginning_of_month
	    end_date = start_date.end_of_month    
	    p "start_date=#{start_date.strftime('%F')}, end_date=#{end_date.strftime('%F')}"

			sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
			p "sg=#{sg.inspect}"

			#######
			# EmailEvents
			welcome_email_total_clicks = 0
			welcome_email_clicks = {}
			welcome_email_click_events = EmailEvent.where(:category => 'Welcome Email', :event => 'click', :created_at => start_date..end_date)
			p "we have #{welcome_email_click_events.size} Welcome Email CLICK events to process"
			welcome_email_click_events.each do |click_event|
				if welcome_email_clicks.key? click_event[:url]
					welcome_email_clicks[click_event[:url]] = welcome_email_clicks[click_event[:url]] + 1
				else
					welcome_email_clicks[click_event[:url]] = 1
				end
				welcome_email_total_clicks = welcome_email_total_clicks + 1
			end

			welcome_email_bounce_events = EmailEvent.where(:category => 'Welcome Email', :event => 'bounce', :created_at => start_date..end_date)
			p "we have #{welcome_email_bounce_events.size} Welcome Email BOUNCE events to process"

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
			p "we have #{welcome_email_bounce_events.size} Welcome Email BOUNCE events to process"

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
			p "Retrieve sums of email stats for each category"
			
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
				p "got data, welcome_email_data_rows.length=#{welcome_email_data_rows.length}, welcome_email_metrics=#{welcome_email_metrics.inspect}"

				# calculate totals
				welcome_email_data_rows.each do |data_row|
					p "data_row=#{data_row.inspect}"
					row_metrics = data_row['stats'].first['metrics']
					p "row_metrics=#{row_metrics.inspect}"
					#p "metrics['blocks']=#{metrics['blocks']}"
					p "row_metrics['blocks']=#{row_metrics['blocks']}"
					welcome_email_metrics['blocks'] += row_metrics['blocks']
					welcome_email_metrics['bounces'] += row_metrics['bounces']
					welcome_email_metrics['clicks'] += row_metrics['clicks']
					welcome_email_metrics['delivered'] += row_metrics['delivered']
					welcome_email_metrics['unique_opens'] += row_metrics['unique_opens']
					welcome_email_metrics['spam_reports'] += row_metrics['spam_reports']
				end

				p "welcome_email_metrics=#{welcome_email_metrics.inspect}"

		    # locals = {
		    #   :@data => {
		    #     start_date: start_date,
		    #     end_date: end_date,
		    #     rows: data_rows,
		    #     metrics: metrics,
		    #   }
		    # }
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
				p "got data, resend_welcome_email_data_rows.length=#{resend_welcome_email_data_rows.length}, resend_welcome_email_metrics=#{resend_welcome_email_metrics.inspect}"

				# calculate totals
				resend_welcome_email_data_rows.each do |data_row|
					p "data_row=#{data_row.inspect}"
					row_metrics = data_row['stats'].first['metrics']
					p "row_metrics=#{row_metrics.inspect}"
					#p "metrics['blocks']=#{metrics['blocks']}"
					p "row_metrics['blocks']=#{row_metrics['blocks']}"
					resend_welcome_email_metrics['blocks'] += row_metrics['blocks']
					resend_welcome_email_metrics['bounces'] += row_metrics['bounces']
					resend_welcome_email_metrics['clicks'] += row_metrics['clicks']
					resend_welcome_email_metrics['delivered'] += row_metrics['delivered']
					resend_welcome_email_metrics['unique_opens'] += row_metrics['unique_opens']
					resend_welcome_email_metrics['spam_reports'] += row_metrics['spam_reports']
				end

				p "resend_welcome_email_metrics=#{resend_welcome_email_metrics.inspect}"

		    # locals = {
		    #   :@data => {
		    #     start_date: start_date,
		    #     end_date: end_date,
		    #     rows: data_rows,
		    #     metrics: metrics,
		    #   }
		    # }
			else
				p "NOT A 200 response, status_code=#{response.status_code}"
			end

	    locals = {
	      :@data => {
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

	    p "let's render PDF"
	    pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/welcome_email', locals))
	    p "pdf rendered..."

			#if send_email
	      p "send email..."
	      ReportsMailer.welcome_email_report(pdf).deliver
	      p "email sent"
	    # else
	      # p "save file..."
	      # save_path = Rails.root.join('pdfs',"welcome_email.pdf")
	      # File.open(save_path, 'wb') do |file|
	      #   file << pdf
	      # end  
	      # p "file saved" 
	    # end
	  # else
	  # 	p "NOT the 2nd day of the month"
	  # end
	end

end