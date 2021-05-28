class Api::V1::LocationsController < ApiController

	before_action :set_cors_headers
  before_action :set_cache_headers

  def index
    render json: Oj.dump(Location.open.select([:id, :name]).as_json)
  end

  def show
    render json: Oj.dump(Location.find(params[:id]).
      as_json(methods: [:salon_professionals],
              only: [:id, :name, :general_contact_name, :email_address_for_inquiries, :phone_number]))
  end
end
