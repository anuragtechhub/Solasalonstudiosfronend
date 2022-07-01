class Api::SolaCms::LocationsController < Api::SolaCms::ApiController
  before_action :set_location, only: %i[ show update destroy]

  #GET /locations
  def index
    @locations = Location.all
    if params[:search].present? 
      locations = Location.search_by_id(params[:search])
      locations = paginate(locations)
      render json:  { locations: locations }.merge(meta: pagination_details(locations))
    elsif params[:all] == "true"
      render json: { locations: @locations }
    else 
      locations = Location.all
      locations = paginate(locations)
      render json: { locations: locations }.merge(meta: pagination_details(locations))
    end
  end

  #POST /locations
  def create
    @location  =  Location.new(location_params)
    if @location.save
      render json: @location
    else
      Rails.logger.info(@location.errors.messages)
      render json: {error: @location.errors.messages}, status: 400
    end
  end

  #GET /locations/:id
  def show
    render json: @location
  end

  #PUT /locations/:id
  def update
    if @location.update(location_params)
      render json: {message: "Location Successfully Updated."}, status: 200
    else
      Rails.logger.info(@location.errors.messages)
      render json: {error: @location.errors.messages}, status: 400
    end
  end

  #DELETE /locations/:id
  def destroy
    if @location&.destroy
      render json: {message: "location Successfully Deleted."}, status: 200
    else
      @location.errors.messages
      Rails.logger.info(@location.errors.messages)
    end
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(
      :name,
      :url_name, 
      :address_1, 
      :address_2, 
      :city, 
      :state, 
      :postal_code, 
      :email_address_for_inquiries, 
      :phone_number, 
      :general_contact_name, 
      :description, 
      :facebook_url, 
      :twitter_url, 
      :latitude,
      :longitude, 
      :chat_code, 
      :image_1, 
      :image_1_alt_text, 
      :image_2, 
      :image_2_alt_text, 
      :image_3, 
      :image_3_alt_text, 
      :image_4, 
      :image_4_alt_text, 
      :image_5, 
      :image_5_alt_text, 
      :image_6, 
      :image_6_alt_text, 
      :image_7, 
      :image_7_alt_text, 
      :image_8, 
      :image_8_alt_text, 
      :image_9,  
      :image_9_alt_text , 
      :image_10,  
      :image_10_alt_text,
      :image_11,
      :image_11_alt_text,
      :image_12,
      :image_12_alt_text,
      :image_13,
      :image_13_alt_text,
      :image_14,
      :image_14_alt_text,
      :image_15,
      :image_15_alt_text,
      :image_16,
      :image_16_alt_text,
      :image_17,
      :image_17_alt_text,
      :image_18,
      :image_18_alt_text,
      :image_19,
      :image_19_alt_text,
      :image_20,
      :image_20_alt_text,
      :status,
      :admin_id,
      :msa_id,
      :move_in_special,
      :open_house,
      :instagram_url,
      :mailchimp_list_ids,
      :callfire_list_ids,
      :custom_maps_url,
      :tracking_code,
      :tour_iframe_1,
      :tour_iframe_2,
      :tour_iframe_3,
      :country,
      :email_address_for_reports,
      :rent_manager_property_id,
      :rent_manager_location_id,
      :service_request_enabled,
      :walkins_enabled,
      :max_walkins_time,
      :walkins_end_of_day,
      :walkins_timezone,
      :floorplan_image,
      :store_id,
      :email_address_for_hubspot,
      :rockbot_manager_email,
      :emails_for_stylist_website_approvals) 
  end 
end
