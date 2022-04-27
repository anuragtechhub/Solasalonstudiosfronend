# frozen_string_literal: true

class Pro::ApiController < Pro::ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :restrict_api_access

  protected

    def restrict_api_access
      account = Account.find_by(api_key: params[:api_key])
      render json: { api_key: ['invalid'] }, status: :unprocessable_entity unless account
    end

    def get_userable_country(email = nil)
      userable = get_user(email)

      if userable.respond_to?(:locations) && userable.locations.size >= 1
        userable.locations.first.country
      elsif userable.respond_to?(:location) && userable&.location
        userable.location.country
      elsif userable.respond_to?(:sola_pro_country_admin)
        userable.sola_pro_country_admin
      else
        'US'
      end
    end

    def get_userable_country_v2(email = nil)
      userable = get_user(email)

      userable&.location_country
    end
end
