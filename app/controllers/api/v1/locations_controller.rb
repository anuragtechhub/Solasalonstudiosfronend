class Api::V1::LocationsController < ApiController

  def index
    @locations = Location.where(:status => 'open')
    render :json => Oj.dump(@locations.select([:id, :name]))
  end

  def show
    @location = Location.find_by(:id => params[:id])
    render :json => Oj.dump(@location.as_json(:methods => [:floorplan_image_url, :directory_image_1_url, :directory_image_2_url, :directory_image_3_url, :directory_image_4_url, :directory_image_5_url, :directory_image_6_url, :directory_image_7_url, :directory_image_8_url, :directory_image_9_url, :directory_image_10_url, :directory_image_11_url, :directory_image_12_url, :salon_professionals], :only => [:id, :name, :general_contact_name, :email_address_for_inquiries, :phone_number]))
  end

end