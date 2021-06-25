class EmailsController < PublicWebsiteController
	def welcome_to_sola
		@browser = true
		locale = I18n.locale.to_s == 'en-CA' ? 'ca' : 'us'
		render "public_website_mailer/welcome_email_#{locale}", layout: false
	end
end
