class Api::V1::LocationsController < ApiController

	before_action :set_cors_headers
  before_action :set_cache_headers

  def index
    json = Rails.cache.fetch("/api/v1/index/#{Location.maximum(:updated_at).to_i}", expires_in: 12.hours) do
      render_to_string json: Oj.dump(Location.open.select([:id, :name]).as_json)
    end
    render json: json
  end

  def show
    json = Rails.cache.fetch("/api/v1/show/#{params[:id]}/#{Stylist.where(location_id: params[:id]).not_reserved.maximum(:updated_at).to_i}", expires_in: 12.hours) do
      render_to_string json: Oj.dump(Location.find(params[:id]).
        as_json(methods: [:salon_professionals],
                only: [:id, :name, :general_contact_name, :email_address_for_inquiries, :phone_number]))
    end
    render json: json
  end
end
