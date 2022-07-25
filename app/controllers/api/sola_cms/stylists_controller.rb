# frozen_string_literal: true
class Api::SolaCms::StylistsController < Api::SolaCms::ApiController
  before_action :get_salon_profession, only: %i[show update]
  
  def index
    if params[:status] == 'active'
      active_stylists = Stylist.active
      active_stylists = active_stylists.search_stylist(params[:search]) if params[:search].present? 
      active_stylists = paginate(active_stylists)
      render json:  { active_stylists: active_stylists }.merge(meta: pagination_details(active_stylists))      
    elsif params[:status] == 'inactive'
      inactivate_stylists = Stylist.inactive
      inactivate_stylists = inactivate_stylists.search_stylist(params[:search]) if params[:search].present?       
      inactive_stylists = paginate(inactive_stylists)
      render json:  { inactive_stylists: inactive_stylists }.merge(meta: pagination_details(inactive_stylists))      
    else
      stylists = Stylist.all
      stylists = stylists.search_stylist(params[:search]) if params[:search].present?             
      stylists = paginate(stylists)
      render json:  { stylists: stylists }.merge(meta: pagination_details(stylists))      
    end           
  end 


  def create
    @stylist = Stylist.new(salon_params)
    if @stylist.save
      render json: @stylist
    else
      Rails.logger.info(@stylist.errors.messages)
      render json: {error: @stylist.errors.messages}, status: 400 
    end
  end 

  def update
    if @stylist.update(salon_params)
      render json: {message: "Styist Successfully Updated." }, status: 200
    else
      Rails.logger.info(@stylist.errors.messages)
      render json: {error: @stylist.errors.messages}, status: 400
    end
  end

  def show
    render json: @stylist
  end

  private 
  
  def get_salon_profession
    @stylist = Stylist.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @stylist.present?
  end

  def salon_params
    params.require(:stylist).permit(
      :id, 
      :name,
      :f_name,
      :m_name,
      :l_name,
      :url_name,
      :biography,
      :email_address,
      :phone_number,
      :studio_number,
      :work_hours,
      :website_url,
      :business_name,
      :hair,
      :skin,
      :nails,
      :massage,
      :teeth_whitening,
      :eyelash_extensions,
      :makeup,
      :tanning,
      :waxing,
      :brows,
      :accepting_new_clients,
      :booking_url,
      :location_id,
      :legacy_id,
      :status,
      :image_1_file_name,
      :image_2_file_name,
      :image_3_file_name,
      :image_4_file_name,
      :image_5_file_name,
      :image_6_file_name,
      :image_7_file_name,
      :image_8_file_name,
      :image_9_file_name,
      :image_10_file_name,
      :hair_extensions,
      :send_a_message_button,
      :pinterest_url,
      :facebook_url,
      :twitter_url,
      :instagram_url,
      :yelp_url,
      :laser_hair_removal,
      :threading,
      :permanent_makeup,
      :linkedin_url,
      :other_service,
      :google_plus_url,
      :password,
      :password_confirmation,
      :msa_name,
      :phone_number_display,
      :sola_genius_enabled,
      :sola_pro_platform,
      :sola_pro_version,
      :image_1_alt_text,
      :image_2_alt_text,
      :image_3_alt_text,
      :image_4_alt_text,
      :image_5_alt_text,
      :image_6_alt_text,
      :image_7_alt_text,
      :image_8_alt_text,
      :image_9_alt_text,
      :image_10_alt_text,
      :microblading,
      :rent_manager_id,
      :date_of_birth,
      :street_address,
      :city,
      :state_province,
      :postal_code,
      :emergency_contact_name,
      :emergency_contact_relationship,
      :emergency_contact_phone_number,
      :cosmetology_license_number,
      :permitted_use_for_studio,
      :country,
      :website_email_address,
      :website_phone_number,
      :website_name,
      :cosmetology_license_date,
      :electronic_license_agreement,
      :force_show_book_now_button,
      :sg_booking_url,
      :walkins,
      :reserved,
      :solagenius_account_created_at,
      :total_booknow_bookings,
      :total_booknow_revenue,
      :walkins_expiry,
      :botox,
      :onboarded,
      :inactive_reason,
      :tik_tok_url,
      :barber,
      :rm_status,
      :billing_email,
      :billing_first_name,
      :billing_last_name,
      :billing_phone,
      :is_deleted,
      testimonial_1_attributes: [:name, :text, :region],
      testimonial_2_attributes: [:name, :text, :region],
      testimonial_3_attributes: [:name, :text, :region],
      testimonial_4_attributes: [:name, :text, :region],
      testimonial_5_attributes: [:name, :text, :region],
      testimonial_6_attributes: [:name, :text, :region],
      testimonial_7_attributes: [:name, :text, :region],
      testimonial_8_attributes: [:name, :text, :region],
      testimonial_9_attributes: [:name, :text, :region],
      testimonial_10_attributes: [:name, :text, :region])
  end

  def render_selected_fields
    fields = params[:fields]&.map!{|f| f.to_sym}
    stylists = Stylist.active.select(fields).where("name ilike ?", "%#{params[:search]}%") if params[:status] == 'active' || params[:status] == nil
    stylists = Stylist.inactive.select(fields).where("name ilike ?", "%#{params[:search]}%") if params[:status] == 'inactive'
    stylists = paginate(stylists)
    render json: { stylists: stylists.as_json(fields: fields) }.merge(meta: pagination_details(stylists))
  end

  def render_all_fields
    stylists = Stylist.send(params[:status])
    stylists = stylists.search_stylist(params[:search]) if params[:search].present?
    meta = {}
      stylists = paginate(stylists)
      meta =  pagination_details(stylists)
    render json: {stylists: stylists, meta: meta}
  end
end
