# frozen_string_literal: true

class CmsController < ApplicationController
  before_action :authorize # , :except => [:sign_in]
  # before_action :authenticate_user!

  def locations_select
    @page = params[:page] || 1
    @results_per_page = params[:results_per_page] || 40

    last_updated_location = Location.select(:updated_at).order(updated_at: :desc).first
    cache_key = "/locations_select?q=#{params[:q]}&page=#{@page}&results_per_page=#{@results_per_page}&last_updated_location=#{last_updated_location}&cai=#{current_admin.id}"

    json = Rails.cache.fetch(cache_key) do
      @locations = current_admin.franchisee ? current_admin.locations : Location.all

      if params[:q]
        q = "%#{params[:q].downcase.gsub(/\s/, '%')}%"
        @locations = @locations.where('LOWER(name) LIKE ? OR LOWER(city) LIKE ? OR LOWER(state) LIKE ?', q, q, q)
      end

      @total_count = @locations.size
      @locations = @locations.order(name: :asc).page(@page).per(@results_per_page)

      render_to_string(formats: 'json')
    end

    render json: json
  end

  def save_lease
    @lease = Lease.find_by(id: params[:lease][:id]) || Lease.new
    @lease.assign_attributes(lease_params)

    Rails.logger.debug { "lease=#{@lease.inspect}" }

    if @lease.save
      Rails.logger.debug 'lease saved successfully!'
      render json: { lease: @lease }
    else
      Rails.logger.debug { "lease NOT saved, #{@lease.errors.full_messages.inspect}" }
      render json: { errors: @lease.errors.full_messages }
    end
  end

  def save_stylist
    @stylist = Stylist.find_by(id: params[:stylist][:id]) || Stylist.new
    @stylist.assign_attributes(stylist_params)

    # images
    set_stylist_images(@stylist)

    # testimonials
    set_stylist_testimonials(@stylist)

    # lease
    set_stylist_lease(@stylist)

    Rails.logger.debug { "stylist=#{@stylist.inspect}" }
    # p "lease=#{@stylist.leases.first.recurring_charge_1}"

    if @stylist.save
      Rails.logger.debug 'stylist saved successfully!'
      render json: { stylist: @stylist }
    else
      Rails.logger.debug { "stylist NOT saved, #{@stylist.errors.full_messages.inspect}" }
      render json: { errors: @stylist.errors.full_messages }
    end
  end

  def studios_select
    @page = params[:page] || 1
    @results_per_page = params[:results_per_page] || 40

    last_updated_studio = Studio.select(:updated_at).order(updated_at: :desc).first
    cache_key = "/studios_select?q=#{params[:q]}&page=#{@page}&results_per_page=#{@results_per_page}&last_updated_studio=#{last_updated_studio}&cai=#{current_admin.id}"

    json = Rails.cache.fetch(cache_key) do
      if params[:location_id].present?
        @studios = Studio.where(location_id: params[:location_id])
      else
        @locations = current_admin.franchisee ? current_admin.locations : Location.all
        @studios = Studio.where(location_id: @locations.map(&:id))
      end

      if params[:q]
        q = "%#{params[:q].downcase.gsub(/\s/, '%')}%"
        @studios = @studios.where('LOWER(name) LIKE ?', q)
      end

      @total_count = @studios.size
      @studios = @studios.order(name: :asc).page(@page).per(@results_per_page)

      render_to_string(formats: 'json')
    end

    render json: json
  end

  def stylists_select
    @page = params[:page] || 1
    @results_per_page = params[:results_per_page] || 40

    last_updated_stylist = Stylist.select(:updated_at).order(updated_at: :desc).first
    cache_key = "/stylists_select?q=#{params[:q]}&page=#{@page}&results_per_page=#{@results_per_page}&last_updated_stylist=#{last_updated_stylist}&cai=#{current_admin.id}"

    json = Rails.cache.fetch(cache_key) do
      if params[:location_id].present?
        @stylists = Stylist.where(location_id: params[:location_id])
      else
        @locations = current_admin.franchisee ? current_admin.locations : Location.all
        @stylists = Stylist.where(location_id: @locations.map(&:id))
      end

      if params[:q]
        q = "%#{params[:q].downcase.gsub(/\s/, '%')}%"
        @stylists = @stylists.where('LOWER(name) LIKE ? OR email_address LIKE ? OR website_email_address LIKE ?', q, q, q)
      end

      @total_count = @stylists.size
      @stylists = @stylists.order(name: :asc).page(@page).per(@results_per_page)

      render_to_string(formats: 'json')
    end

    render json: json
  end

  def s3_presigned_post
    presigned_post = S3_MYSOLAIMAGES_BUCKET.presigned_post({ key: "cms_#{current_admin.id}/#{SecureRandom.uuid}", success_action_status: '201', acl: 'public-read', content_type: params[:content_type] })
    render json: { fields: presigned_post.fields, url: presigned_post.url }
  end

  private

    def authorize
      unless current_admin # User.find_by_id(session[:user_id])
        # session[:user_id] = nil
        redirect_to :rails_admin
      end
    end

    def back_or_index
      params[:return_to].presence && params[:return_to].include?(request.host) && (params[:return_to] != request.fullpath) ? params[:return_to] : '/admin'
    end

    def lease_params
      params.require(:lease).permit(:stylist_id, :studio_id, :location_id, :rent_manager_id, :start_date, :end_date, :move_in_date, :signed_date, :weekly_fee_year_1, :weekly_fee_year_2,
                                    :fee_start_date, :damage_deposit_amount, :product_bonus_amount, :product_bonus_distributor, :special_terms, :ach_authorized,
                                    :agreement_file_url, :location_id, :hair_styling_permitted, :manicure_pedicure_permitted, :waxing_permitted, :massage_permitted,
                                    :facial_permitted, :recurring_charge_1, :recurring_charge_2, :recurring_charge_3, :recurring_charge_4, :move_in_bonus, :move_in_bonus_amount,
                                    :move_in_bonus_payee, :insurance, :insurance_amount, :insurance_frequency)
    end

    def stylist_params
      params.require(:stylist).permit(:name, :url_name, :biography, :email_address, :phone_number, :studio_number, :work_hours, :website_url, :business_name,
                                      :hair, :skin, :nails, :massage, :teeth_whitening, :eyelash_extensions, :makeup, :tanning, :waxing, :brows, :accepting_new_clients,
                                      :booking_url, :location_id, :status, :hair_extensions, :send_a_message_button, :pinterest_url, :facebook_url, :twitter_url, :instagram_url,
                                      :yelp_url, :tik_tok_url, :laser_hair_removal, :threading, :permanent_makeup, :linkedin_url, :other_service, :google_plus_url, :phone_number_display,
                                      :image_1_alt_text, :image_2_alt_text, :image_3_alt_text, :image_4_alt_text, :image_5_alt_text, :image_6_alt_text, :image_7_alt_text,
                                      :image_8_alt_text, :image_9_alt_text, :image_10_alt_text, :microblading, :rent_manager_id, :date_of_birth, :street_address, :city,
                                      :state_province, :postal_code, :emergency_contact_name, :emergency_contact_relationship, :emergency_contact_phone_number, :cosmetology_license_number,
                                      :cosmetology_license_date, :permitted_use_for_studio, :country, :website_email_address, :website_phone_number, :website_name,
                                      :password, :password_confirmation, :electronic_license_agreement)
    end

    def set_stylist_lease(stylist = nil)
      return unless stylist && params[:lease]

      @lease = Lease.find_by(id: params[:lease][:id]) || Lease.new
      @lease.assign_attributes(lease_params)
      @lease.location = stylist.location
      @lease.stylist = stylist

      if params[:lease][:recurring_charge_1] && (params[:lease][:recurring_charge_1][:start_date] || params[:lease][:recurring_charge_1][:end_date] || params[:lease][:recurring_charge_1][:amount]&.to_i&.positive?)
        @lease.recurring_charge_1 = RecurringCharge.find_by(id: params[:lease][:recurring_charge_1][:id]) || RecurringCharge.new
        @lease.recurring_charge_1.amount = params[:lease][:recurring_charge_1][:amount]
        @lease.recurring_charge_1.start_date = params[:lease][:recurring_charge_1][:start_date]
        @lease.recurring_charge_1.end_date = params[:lease][:recurring_charge_1][:end_date]
      end

      if params[:lease][:recurring_charge_2] && (params[:lease][:recurring_charge_2][:start_date] || params[:lease][:recurring_charge_2][:end_date] || params[:lease][:recurring_charge_2][:amount]&.to_i&.positive?)
        @lease.recurring_charge_2 = RecurringCharge.find_by(id: params[:lease][:recurring_charge_2][:id]) || RecurringCharge.new
        @lease.recurring_charge_2.amount = params[:lease][:recurring_charge_2][:amount]
        @lease.recurring_charge_2.start_date = params[:lease][:recurring_charge_2][:start_date]
        @lease.recurring_charge_2.end_date = params[:lease][:recurring_charge_2][:end_date]
      end

      if params[:lease][:recurring_charge_3] && (params[:lease][:recurring_charge_3][:start_date] || params[:lease][:recurring_charge_3][:end_date] || params[:lease][:recurring_charge_3][:amount]&.to_i&.positive?)
        @lease.recurring_charge_3 = RecurringCharge.find_by(id: params[:lease][:recurring_charge_3][:id]) || RecurringCharge.new
        @lease.recurring_charge_3.amount = params[:lease][:recurring_charge_3][:amount]
        @lease.recurring_charge_3.start_date = params[:lease][:recurring_charge_3][:start_date]
        @lease.recurring_charge_3.end_date = params[:lease][:recurring_charge_3][:end_date]
      end

      if params[:lease][:recurring_charge_4] && (params[:lease][:recurring_charge_4][:start_date] || params[:lease][:recurring_charge_4][:end_date] || params[:lease][:recurring_charge_4][:amount]&.to_i&.positive?)
        @lease.recurring_charge_4 = RecurringCharge.find_by(id: params[:lease][:recurring_charge_4][:id]) || RecurringCharge.new
        @lease.recurring_charge_4.amount = params[:lease][:recurring_charge_4][:amount]
        @lease.recurring_charge_4.start_date = params[:lease][:recurring_charge_4][:start_date]
        @lease.recurring_charge_4.end_date = params[:lease][:recurring_charge_4][:end_date]
      end

      # p "set_stylist_lease lease=#{@lease.inspect}"
      # p "set_stylist_lease studio=#{@lease.studio.inspect}"
      # p "set_stylist_lease stylist=#{@lease.stylist.inspect}"
      stylist.leases << @lease
      # p "set_stylist_lease stylist.leases=#{stylist.leases.size}"
    end

    def set_stylist_testimonials(stylist = nil)
      return unless stylist

      if params[:stylist][:testimonial_1].present?
        # p "yes, testimonial 1 is present..."
        stylist.build_testimonial_1 if stylist.testimonial_1.blank?
        stylist.testimonial_1.name = params[:stylist][:testimonial_1][:name]
        stylist.testimonial_1.text = params[:stylist][:testimonial_1][:text]
        stylist.testimonial_1.region = params[:stylist][:testimonial_1][:region]
        # p "boom, set testimonial 1=#{stylist.testimonial_1.inspect}"
      end

      if params[:stylist][:testimonial_2].present?
        # p "yes, testimonial 2 is present..."
        stylist.build_testimonial_2 if stylist.testimonial_2.blank?
        stylist.testimonial_2.name = params[:stylist][:testimonial_2][:name]
        stylist.testimonial_2.text = params[:stylist][:testimonial_2][:text]
        stylist.testimonial_2.region = params[:stylist][:testimonial_2][:region]
        # p "boom, set testimonial 2=#{stylist.testimonial_2.inspect}"
      end

      if params[:stylist][:testimonial_3].present?
        # p "yes, testimonial 3 is present..."
        stylist.build_testimonial_3 if stylist.testimonial_3.blank?
        stylist.testimonial_3.name = params[:stylist][:testimonial_3][:name]
        stylist.testimonial_3.text = params[:stylist][:testimonial_3][:text]
        stylist.testimonial_3.region = params[:stylist][:testimonial_3][:region]
        # p "boom, set testimonial 3=#{stylist.testimonial_3.inspect}"
      end

      if params[:stylist][:testimonial_4].present?
        # p "yes, testimonial 1 is present..."
        stylist.build_testimonial_4 if stylist.testimonial_4.blank?
        stylist.testimonial_4.name = params[:stylist][:testimonial_4][:name]
        stylist.testimonial_4.text = params[:stylist][:testimonial_4][:text]
        stylist.testimonial_4.region = params[:stylist][:testimonial_4][:region]
        # p "boom, set testimonial 4=#{stylist.testimonial_4.inspect}"
      end

      if params[:stylist][:testimonial_5].present?
        # p "yes, testimonial 5 is present..."
        stylist.build_testimonial_5 if stylist.testimonial_5.blank?
        stylist.testimonial_5.name = params[:stylist][:testimonial_5][:name]
        stylist.testimonial_5.text = params[:stylist][:testimonial_5][:text]
        stylist.testimonial_5.region = params[:stylist][:testimonial_5][:region]
        # p "boom, set testimonial 5=#{stylist.testimonial_5.inspect}"
      end

      if params[:stylist][:testimonial_6].present?
        # p "yes, testimonial 6 is present..."
        stylist.build_testimonial_6 if stylist.testimonial_6.blank?
        stylist.testimonial_6.name = params[:stylist][:testimonial_6][:name]
        stylist.testimonial_6.text = params[:stylist][:testimonial_6][:text]
        stylist.testimonial_6.region = params[:stylist][:testimonial_6][:region]
        # p "boom, set testimonial 6=#{stylist.testimonial_6.inspect}"
      end

      if params[:stylist][:testimonial_7].present?
        # p "yes, testimonial 7 is present..."
        stylist.build_testimonial_7 if stylist.testimonial_7.blank?
        stylist.testimonial_7.name = params[:stylist][:testimonial_7][:name]
        stylist.testimonial_7.text = params[:stylist][:testimonial_7][:text]
        stylist.testimonial_7.region = params[:stylist][:testimonial_7][:region]
        # p "boom, set testimonial 7=#{stylist.testimonial_7.inspect}"
      end

      if params[:stylist][:testimonial_8].present?
        # p "yes, testimonial 8 is present..."
        stylist.build_testimonial_8 if stylist.testimonial_8.blank?
        stylist.testimonial_8.name = params[:stylist][:testimonial_8][:name]
        stylist.testimonial_8.text = params[:stylist][:testimonial_8][:text]
        stylist.testimonial_8.region = params[:stylist][:testimonial_8][:region]
        # p "boom, set testimonial 8=#{stylist.testimonial_8.inspect}"
      end

      if params[:stylist][:testimonial_9].present?
        # p "yes, testimonial 9 is present..."
        stylist.build_testimonial_9 if stylist.testimonial_9.blank?
        stylist.testimonial_9.name = params[:stylist][:testimonial_9][:name]
        stylist.testimonial_9.text = params[:stylist][:testimonial_9][:text]
        stylist.testimonial_9.region = params[:stylist][:testimonial_9][:region]
        # p "boom, set testimonial 9=#{stylist.testimonial_9.inspect}"
      end

      if params[:stylist][:testimonial_10].present?
        # p "yes, testimonial 10 is present..."
        stylist.build_testimonial_10 if stylist.testimonial_10.blank?
        stylist.testimonial_10.name = params[:stylist][:testimonial_10][:name]
        stylist.testimonial_10.text = params[:stylist][:testimonial_10][:text]
        stylist.testimonial_10.region = params[:stylist][:testimonial_10][:region]
        # p "boom, set testimonial 10=#{stylist.testimonial_10.inspect}"
      end
    end

    def set_stylist_images(stylist = nil)
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
