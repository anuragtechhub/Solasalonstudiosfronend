# frozen_string_literal: true

class StylistsController < PublicWebsiteController
  skip_before_action :auth_if_test, only: :show
  skip_before_action :verify_authenticity_token, only: :send_a_message

  def index
    redirect_to(:locations, status: :moved_permanently) and return if I18n.locale.to_s == 'pt-BR'
  end

  def show
    @stylist = Stylist.find_by(url_name: params[:url_name])

    unless @stylist
      @stylist = Stylist.find_by(url_name: params[:url_name].split('_').join('-'))
      redirect_to(show_salon_professional_path(url_name: @stylist.url_name), status: :moved_permanently) and return if @stylist
    end

    if @stylist && (@stylist.reserved || @stylist.inactive?)
      redirect_to(salon_stylists_path(@stylist.location.url_name)) and return
    end

    @location = @stylist.location if @stylist&.location
    if @location
      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    end
    redirect_to(:salon_professionals, status: :moved_permanently) and return unless @stylist && @location && @location.status == 'open'
  end

  def send_a_message
    if request.post?
      captcha_verified = verify_recaptcha
      if (params[:name]&.present? && params[:email] && params[:email].present?) && captcha_verified
        # ensure it's not a banned IP address
        unless banned_ip_addresses.include? request.remote_ip
          msg = StylistMessage.create(name: params[:name], email: params[:email], phone: params[:phone], message: params[:message], stylist_id: params[:stylist_id])
          msg.visit = save_visit
          msg.save
        end
        render json: { success: 'Thank you for your message!' }
      elsif captcha_verified
        render json: { error: 'Please enter your name and email address' }
      else
        render json: { error: 'No robots allowed. Please check the box to prove you are a human.' }
      end
    end
  end

  def going_independent_contact_form_success
    @success_redirect_url = going_independent_contact_form_success_path
    @contact_form_success = true
    @scroll_top = params[:s_t]
    @success = 'Thank you! We will get in touch soon'
    @body_class = 'goingindependent'
    @no_header = true

    render 'going_independent'
  end

  def going_independent
    @success_redirect_url = going_independent_contact_form_success_path
    @body_class = 'goingindependent'
    @no_header = true
  end

  def financial_guide_contact_form_success
    @success_redirect_url = financial_guide_contact_form_success_path
    @contact_form_success = true
    @scroll_top = params[:s_t]
    @success = 'Thank you! We will get in touch soon'
    @body_class = 'financialguide'
    @no_header = true

    render 'financial_guide'
  end

  def financial_guide
    @success_redirect_url = financial_guide_contact_form_success_path
    @body_class = 'financialguide'
    @no_header = true
  end

  def redirect
    @stylist = Stylist.find_by(url_name: params[:url_name])
    @location = @stylist.location if @stylist&.location
    if @stylist && @location
      redirect_to show_salon_professional_path(@stylist).gsub(/\./, ''), status: :moved_permanently
    else
      redirect_to :salon_professionals, status: :moved_permanently
    end
  end

  private

    def save_visit
      visit = Visit.new

      visit.uuid = request.uuid
      visit.ip_address = request.remote_ip
      visit.user_agent_string = request.env['HTTP_USER_AGENT']

      if visit.save
        visit
      end
    end
end
