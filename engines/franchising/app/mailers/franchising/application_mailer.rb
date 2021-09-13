module Franchising
	class ApplicationMailer < ActionMailer::Base
		default from: 'form-submission@solafranchising.com'
		layout false

		def franchising_form(franchising_form)
			@franchising_form = franchising_form
			mail(to: 'solasalons@myfranconnect.com, leads@hotdishad.com', subject: 'FranConnect Franchising Email')
		end
	end
end