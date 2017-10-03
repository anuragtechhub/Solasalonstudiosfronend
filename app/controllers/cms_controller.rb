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
    @stylist = Stylist.find_by(:id => params[:stylist][:id]) || Stylist.new
    @stylist.assign_attributes(stylist_params)

    # images
    set_stylist_images(@stylist)

    # testimonials
    set_stylist_testimonials(@stylist)

    # lease
    
    p "stylist=#{@stylist.inspect}"

    if @stylist.save
      p "stylist saved successfully! #{@stylist.image_1_url}"
      render :json => {:stylist => @stylist}
    else
      p "stylist NOT saved, #{@stylist.errors.full_messages.inspect}"
      render :json => {:errors => @stylist.errors.full_messages}
    end
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

  def set_stylist_testimonials(stylist=nil)
    return unless stylist


  end

  def set_stylist_images(stylist=nil)
    return unless stylist
    
    if params[:stylist][:image_1_url].present? && params[:stylist][:image_1_url] != stylist.image_1_url 
      stylist.image_1 = open(params[:stylist][:image_1_url])
    end
  
    if params[:stylist][:image_2_url].present? && params[:stylist][:image_2_url] != stylist.image_2_url 
      stylist.image_2 = open(params[:stylist][:image_2_url])
    end

    if params[:stylist][:image_3_url].present? && params[:stylist][:image_3_url] != stylist.image_3_url 
      stylist.image_3 = open(params[:stylist][:image_3_url])
    end  

    if params[:stylist][:image_4_url].present? && params[:stylist][:image_4_url] != stylist.image_4_url 
      stylist.image_4 = open(params[:stylist][:image_4_url])
    end    

    if params[:stylist][:image_5_url].present? && params[:stylist][:image_5_url] != stylist.image_5_url 
      stylist.image_5 = open(params[:stylist][:image_5_url])
    end   

    if params[:stylist][:image_6_url].present? && params[:stylist][:image_6_url] != stylist.image_6_url 
      stylist.image_6 = open(params[:stylist][:image_6_url])
    end

    if params[:stylist][:image_7_url].present? && params[:stylist][:image_7_url] != stylist.image_7_url 
      stylist.image_7 = open(params[:stylist][:image_7_url])
    end             

    if params[:stylist][:image_8_url].present? && params[:stylist][:image_8_url] != stylist.image_8_url 
      stylist.image_8 = open(params[:stylist][:image_8_url])
    end      

    if params[:stylist][:image_9_url].present? && params[:stylist][:image_9_url] != stylist.image_9_url 
      stylist.image_9 = open(params[:stylist][:image_9_url])
    end    

    if params[:stylist][:image_10_url].present? && params[:stylist][:image_10_url] != stylist.image_10_url 
      stylist.image_10 = open(params[:stylist][:image_10_url])
    end        
  end

end