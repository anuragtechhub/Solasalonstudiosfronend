# frozen_string_literal: true
class Api::SolaCms::StylistsController < Api::SolaCms::ApiController
  before_action :get_salon_profession, only: %i[show update]
  
  def index
    if params[:status].present? && params[:fields].present?
      render_selected_fields
    elsif params[:status].present?
      render_all_fields
    else
      render_selected_fields
    end
  end

  def create
    @stylist = Stylist.new(salon_params)
    if @stylist.save
      render json: @stylist, status: 200
    else
      Rails.logger.info(@stylist.errors.messages)
      render json: {error: @stylist.errors.messages}, status: 400 
    end
  end 

  def update
    if @stylist.update(salon_params)
      render json: {message: "Stylist Successfully Updated." }, status: 200
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
      :image_1,
      :image_2,
      :image_3,
      :image_4,
      :image_5,
      :image_6,
      :image_7,
      :image_8,
      :image_9,
      :image_10,
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
      testimonial_1_attributes: [:id, :name, :text, :region, :_destroy],
      testimonial_2_attributes: [:id, :name, :text, :region, :_destroy],
      testimonial_3_attributes: [:id, :name, :text, :region, :_destroy],
      testimonial_4_attributes: [:id, :name, :text, :region, :_destroy],
      testimonial_5_attributes: [:id, :name, :text, :region, :_destroy],
      testimonial_6_attributes: [:id, :name, :text, :region, :_destroy],
      testimonial_7_attributes: [:id, :name, :text, :region, :_destroy],
      testimonial_8_attributes: [:id, :name, :text, :region, :_destroy],
      testimonial_9_attributes: [:id, :name, :text, :region, :_destroy],
      testimonial_10_attributes: [:id, :name, :text, :region, :_destroy])
  end

  def render_selected_fields
    fields = params[:fields]&.map!{|f| f.to_sym}
    stylists = Stylist.active.select(fields).order("#{field} #{order}") if params[:status] == 'active' || params[:status] == nil
    stylists = Stylist.inactive.select(fields).order("#{field} #{order}") if params[:status] == 'inactive'
    stylists = stylists.search_stylist(params[:search]) if params[:search].present?
    stylists = paginate(stylists)
    render json: { stylists: stylists.as_json(fields: fields) }.merge(meta: pagination_details(stylists))
  end

  def render_all_fields
    stylists = Stylist.order("#{field} #{order}").send(params[:status])
    stylists = stylists.order("#{field} #{order}").search_stylist(params[:search]) if params[:search].present?
    stylists = paginate(stylists)
    meta =  pagination_details(stylists)
    render json: {stylists: stylists, meta: meta}
  end
end
