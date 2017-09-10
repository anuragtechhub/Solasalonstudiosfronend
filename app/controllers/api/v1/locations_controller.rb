class Api::V1::LocationsController < ApiController

  def index
    @locations = Location.where(:status => 'open')
    render :json => Oj.dump(@locations.select([:id, :name]))
  end

  def show
    @location = Location.find_by(:id => params[:id])
    render :json => Oj.dump(@location.as_json(:methods => [:salon_professionals], :only => [:id, :name, :general_contact_name, :email_address_for_inquiries, :phone_number]))
  end

end