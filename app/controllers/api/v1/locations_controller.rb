class Api::V1::LocationsController < ApiController

	before_action :set_cors_headers

  def index
    @locations = Location.where(:status => 'open')
    render :json => Oj.dump(@locations.select([:id, :name]))
  end

  def show
    @location = Location.find_by(:id => params[:id])
    render :json => Oj.dump(@location.as_json(:methods => [:salon_professionals], :only => [:id, :name, :general_contact_name, :email_address_for_inquiries, :phone_number]))
  end

  private

  def set_cors_headers
  	headers['Access-Control-Allow-Origin'] = '*.spydersoft.com'
		headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
		headers['Access-Control-Request-Method'] = '*'
		headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
	end

end