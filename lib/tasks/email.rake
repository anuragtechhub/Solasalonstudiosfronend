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
end
