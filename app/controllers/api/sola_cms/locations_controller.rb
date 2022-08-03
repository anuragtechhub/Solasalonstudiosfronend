class Api::SolaCms::LocationsController < Api::SolaCms::ApiController
  before_action :set_location, only: %i[ show update destroy]

  #GET /locations
  def index
    @locations = params[:search].present? ? search_location : Location.order("#{field} #{order}")
    render json: { locations: @locations } and return if params[:all] == "true"
    @locations = paginate(@locations)
    render json:  { locations: @locations }.merge(meta: pagination_details(@locations))
  end

  #POST /locations
  def create
    @location  =  Location.new(location_params)
    country_code = Country.find_by(id: location_params["country_id"]).code
    @location[:country] = country_code
    if @location.save
      render json: @location, status: 200
    else
      Rails.logger.error(@location.errors.messages)
      render json: {error: @location.errors.messages}, status: 400
    end
  end

  #GET /locations/:id
  def show
    render json: @location
  end

  #PUT /locations/:id
  def update
    country_code = Country.find_by(id: location_params["country_id"]).code
    @location[:country] = country_code
    if @location.update(location_params)
      render json: {message: "Location Successfully Updated."}, status: 200
    else
      Rails.logger.error(@location.errors.messages)
      render json: {error: @location.errors.messages}, status: 400
    end
  end

  #DELETE /locations/:id
  def destroy
    begin
      if @location&.destroy
        render json: {message: "location Successfully Deleted."}, status: 200
      end
    rescue ActiveRecord::RecordNotDestroyed => error
      render json: {error: @location.errors.messages }, status: 400 
      Rails.logger.error(@location.errors.messages)
    rescue ActiveRecord::InvalidForeignKey => error
      render json: {error: "Location Can't be Delete For Now" }, status: 400 
      Rails.logger.error(@location.errors.messages)
    end 
  end

  private

  def set_location
    @location = Location.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @location.present?
  end
  
  def search_location
    Location.order("#{field} #{order}").search_location_by_columns(params[:search])
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
      :country_id,
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
      :legacy_id,
      :pinterest_url,
      :yelp_url,
      :moz_id,
      :description_short,
      :description_long,
      :open_time,
      :close_time,
      :delete_image_1,
      :delete_image_2, 
      :delete_image_3, 
      :delete_image_4, 
      :delete_image_5, 
      :delete_image_6, 
      :delete_image_7, 
      :delete_image_8, 
      :delete_image_9, 
      :delete_image_10, 
      :delete_image_11, 
      :delete_image_12, 
      :delete_image_13, 
      :delete_image_14, 
      :delete_image_15, 
      :delete_image_16, 
      :delete_image_17, 
      :delete_image_18, 
      :delete_image_19, 
      :delete_image_20, 
      :delete_floorplan_image,
      :emails_for_stylist_website_approvals) 
  end 
end