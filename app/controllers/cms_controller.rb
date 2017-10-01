class CmsController < ApplicationController

  before_filter :authorize#, :except => [:sign_in]
  #before_action :authenticate_user!
  
  def locations_select
    @page = params[:page] || 1
    @results_per_page = params[:results_per_page] || 40
    
    last_updated_location = Location.select(:updated_at).order(:updated_at => :desc).first
    cache_key = "/locations_select?q=#{params[:q]}&page=#{@page}&results_per_page=#{@results_per_page}&last_updated_location=#{last_updated_location}&cai=#{current_admin.id}"

    json = Rails.cache.fetch(cache_key) do 
      @locations = current_admin.franchisee ? current_admin.locations : Location.all

      if params[:q]
        q = "%#{params[:q].downcase.gsub(/\s/, '%')}%"
        @locations = @locations.where('LOWER(name) LIKE ? OR LOWER(city) LIKE ? OR LOWER(state) LIKE ?', q, q, q)
      end

      @total_count = @locations.size
      @locations = @locations.order(:name => :asc).page(@page).per(@results_per_page)

      render_to_string(formats: 'json')
    end

    render :json => json
  end

  def save_stylist
    @stylist = Stylist.find(params[:stylist][:id]) || Stylist.new
    @stylist.assign_attributes(stylist_params)

    # images

    # testimonials

    # lease
    
    p "stylist=#{@stylist.inspect}"
    
    render :json => @stylist
  end

  def studios_select

  end

  def stylists_select

  end

  def s3_presigned_post
    presigned_post = S3_MYSOLAIMAGES_BUCKET.presigned_post({key: "cms_#{current_admin.id}/#{SecureRandom.uuid}", success_action_status: '201', acl: 'public-read', content_type: params[:content_type]})
    render :json => {fields: presigned_post.fields, url: presigned_post.url}
  end
  
  private

  def authorize
    unless current_admin#User.find_by_id(session[:user_id])
      #session[:user_id] = nil
      redirect_to :rails_admin
    end
  end   

  def stylist_params
    params.require(:stylist).permit(:name, :url_name, :biography, :email_address, :phone_number, :studio_number, :work_hours, :website_url, :business_name, 
                                    :hair, :skin, :nails, :massage, :teeth_whitening, :eyelash_extensions, :makeup, :tanning, :waxing, :brows, :accepting_new_clients,
                                    :booking_url, :location_id, :status, :hair_extensions, :send_a_message_button, :pinterest_url, :facebook_url, :twitter_url, :instagram_url, 
                                    :yelp_url, :laser_hair_removal, :threading, :permanent_makeup, :linkedin_url, :other_service, :google_plus_url, :phone_number_display,
                                    :image_1_alt_text, :image_2_alt_text, :image_3_alt_text, :image_4_alt_text, :image_5_alt_text, :image_6_alt_text, :image_7_alt_text, 
                                    :image_8_alt_text, :image_9_alt_text, :image_10_alt_text, :microblading, :rent_manager_id, :date_of_birth, :street_address, :city,
                                    :state_province, :postal_code, :emergency_contact_name, :emergency_contact_relationship, :emergency_contact_phone_number, :cosmetology_license_number,
                                    :permitted_use_for_studio, :country, :website_email_address, :website_phone_number, :website_name)
  end

end