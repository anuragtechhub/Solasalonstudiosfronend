require_dependency 'franchising/application_controller'

module Franchising
	class FranchisingFormController < ApplicationController

		def create
			ff = FranchisingForm.new(create_params)
			@success = ff.save
		end

		private

		def create_params
			params.permit(
				:first_name, :last_name, :email_address, :phone_number,
				:multi_unit_operator, :liquid_capital, :city, :state,
				:agree_to_receive_email, :utm_source, :utm_campaign,
				:utm_medium, :utm_content, :utm_term, :country
			).tap do |permitted|
				permitted[:multi_unit_operator] = permitted[:multi_unit_operator].to_s.downcase == 'yes'
			end
		end
	end
end