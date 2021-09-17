require_dependency 'franchising/application_controller'

module Franchising
	class FilesController < ApplicationController
		def pdf_guide
			source_name = if canadian_locale?
				'Sola_Franchise_Brochure_CAN_9.1.21_Final.pdf'
			else
				'Sola Salon Studios Franchise Guide.pdf'
			end

			send_file(
				Rails.root.join('public', 'franchising', 'pdfs', source_name),
				type: 'application/pdf',
				disposition: 'attachment',
				filename: 'Sola_Franchise_Guide.pdf'
			)
		end
	end
end