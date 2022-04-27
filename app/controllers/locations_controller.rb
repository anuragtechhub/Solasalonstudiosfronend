# frozen_string_literal: true

class LocationsController < PublicWebsiteController
  before_action :map_defaults

  def find_salon
    if params[:query]
      query_param = "%#{params[:query].downcase.gsub(/\s/, '%')}%"

      # locations
      locations1 = Location.near(params[:query].downcase).where(country: (I18n.locale == :en ? 'US' : 'CA'))
      locations2 = Location.where(country: (I18n.locale == :en ? 'US' : 'CA')).where(status: 'open').where('LOWER(state) LIKE ? OR LOWER(city) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param, query_param).where(country: (I18n.locale == :en ? 'US' : 'CA'))
      locations3 = Location.where(msa_id: Msa.where('LOWER(name) LIKE ?', query_param).select(:id).to_a).where(country: (I18n.locale == :en ? 'US' : 'CA'))

      @locations = locations1.open + locations2.open + locations3.open
      if @locations
        @locations.uniq!
        @locations.sort! { |a, b| a.name <=> b.name }
      end
    end

    render json: @locations.to_json(only: %i[name url_name email_address_for_inquiries general_contact_name phone_number city state], methods: [:full_address])
  end

  def index
    @country = country_from_locale
    @locations = Location.where(status: 'open').where(country: @country)
    @states = @locations.select('DISTINCT state').order(state: :asc).to_a.reject { |l| l.state.blank? }

    # p "@locations=#{@locations.inspect}"
    # p "@states=#{@states.to_a.length}"

    @last_location = Location.order(updated_at: :desc).first
    @last_msa = Msa.order(updated_at: :desc).first
  end

  def region
    @msa = Msa.find_by(url_name: params[:url_name])

    unless @msa
      @msa = Msa.find_by(url_name: params[:url_name].split('_').join('-'))
      redirect_to(region_path(url_name: @msa.url_name), status: :moved_permanently) if @msa
    end

    @all_locations = if I18n.locale == :en
                       Location.where(status: 'open').where(country: 'US')
                     else
                       Location.where(status: 'open').where(country: 'CA') # .where.not(:id => 362)
                     end

    if @msa
      @locations = @all_locations.where(msa_id: @msa.id)
      params[:state] = @locations.first.state if @locations.first.present?
    else
      redirect_to :locations, status: :moved_permanently
    end
  end

  def city
    @all_locations = Location.where(status: 'open')
    query_param = "%#{params[:city]}%"

    # locations1 = Location.where(:status => 'open').near(params[:city])
    @locations = if I18n.locale == :en
                   Location.where(status: 'open').where(country: 'US')
                 else
                   Location.where(status: 'open').where(country: 'CA') # .where.not(:id => 362)
                 end

    @locations = @locations.where('city LIKE ?', query_param)
    # @locations = locations1 + locations2
    if @locations
      @locations.uniq!
      @locations.sort! { |a, b| a.name <=> b.name }
    end
    redirect_to(:locations, status: :moved_permanently) unless @locations.size.positive? && @lat && @lng
  end

  def state
    @all_locations = if I18n.locale == :en
                       Location.where(status: 'open').where(country: 'US')
                     else
                       Location.where(status: 'open').where(country: 'CA') # .where.not(:id => 362)
                     end

    query_param = params[:state].downcase.gsub(/-/, ' ').to_s.strip if params[:state]

    Rails.logger.debug { "query_param=#{query_param}" }

    @locations = if I18n.locale == :en
                   Location.where(status: 'open').where('lower(state) = ?', query_param).where(country: 'US')
                 else
                   Location.where(status: 'open').where('lower(state) = ?', query_param).where(country: 'CA') # .where.not(:id => 362)
                 end

    # Country check
    location = @locations.first
    if location && location.country == 'US' && I18n.locale.to_s != 'en'
      redirect_to(:locations, status: :moved_permanently)
    elsif location && location.country == 'CA' && I18n.locale.to_s != 'en-CA'
      redirect_to(:locations, status: :moved_permanently)
    end

    redirect_to(:locations, status: :moved_permanently) unless @locations.size.positive? && @lat && @lng
  end

  def contact_form_success
    @success_redirect_url = location_contact_form_success_path
    @contact_form_success = true
    @scroll_top = params[:s_t]
    @success = 'Thank you! We will get in touch soon'

    @location = Location.find_by(url_name: params[:url_name], status: 'open')
    @articles = Article.where(location_id: @location.id).order('created_at DESC') if @location

    if @location
      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
      render 'salon'
    else
      redirect_to :locations, status: :moved_permanently
    end
  end

  def salon
    @success_redirect_url = location_contact_form_success_path
    @location = Location.find_by(url_name: params[:url_name], status: 'open')

    # Country check
    if @location && @location.country == 'US' && I18n.locale.to_s != 'en'
      redirect_to(:locations, status: :moved_permanently)
    elsif @location && @location.country == 'CA' && I18n.locale.to_s != 'en-CA'
      redirect_to(:locations, status: :moved_permanently)
    end

    @articles = Article.where(location_id: @location.id).order('created_at DESC') if @location

    if @location
      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    else
      redirect_to :locations, status: :moved_permanently
    end
  end

  def usa
    Rails.logger.debug { "USA!- request.remote_ip=#{request.remote_ip}" }
    location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
    Rails.logger.debug { "USA!- location=#{location.inspect}" }
    Rails.logger.debug { "USA!- city, state=#{location.city}, #{location.state}" }
    if location && location.state.present?
      Rails.logger.debug 'USA!- redirect1'
      redirect_to locations_by_state_path(params.merge({ state: location.state })), status: :moved_permanently
    else
      Rails.logger.debug 'USA!- redirect2'
      redirect_to locations_path(params), status: :moved_permanently
    end
  rescue StandardError => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    redirect_to locations_path(params), status: :moved_permanently
  end

  def state_abbr_to_name(abbr); end

  def old_salon
    redirect_to salon_location_path(url_name: params[:url_name].split('_').join('-')), status: :moved_permanently
  end

  def salon_redirect
    @location = Location.find_by(url_name: params[:url_name])

    if @location&.state && @location&.city
      redirect_to salon_location_path(@location.state, @location.city, @location.url_name).gsub(/\./, ''), status: :moved_permanently
    else
      redirect_to :locations, status: :moved_permanently
    end
  end

  def stylists
    @location = Location.find_by(url_name: params[:url_name], status: 'open')

    if @location&.stylists
      if params[:service].present?
        @stylists = @location.stylists.where(reserved: false).select { |s| s.services.include?(params[:service]) || (params[:service].downcase == 'other' && s.other_service) }
      else
        @stylists = @location.stylists.where(reserved: false)
        @reserved_stylists = @location.stylists.where(reserved: true).order(studio_number: :asc)
      end
      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    else
      redirect_to :locations, status: :moved_permanently
    end
  end

  def fullscreen
    @locations = Location.all
    render layout: 'fullscreen'
  end

  # custom location redirects
  def sixthaveredirect
    redirect_to 'https://www.solasalonstudios.com/locations/tacoma-6th-avenue', status: :moved_permanently
  end

  private

    def country_from_locale
      Rails.logger.debug { "country_from_locale=#{I18n.locale}" }
      case I18n.locale.to_s
      when 'pt-BR'
        'BR'
      when 'en-CA'
        'CA'
      else
        'US'
      end
    end

    def map_defaults
      case params[:action]
      when 'city'
        # TODO: store it somewhere
        cache_key = "#{params[:city]}, #{params[:state]}"
        coords = Rails.cache.fetch(cache_key) do
          Geocoder.coordinates(cache_key)
        end

        if coords && coords.size > 1
          @lat = coords[0]
          @lng = coords[1]
          @zoom = 9
        end
      when 'state'
        cache_key = "#{I18n.locale == :en ? 'USA' : 'Canada'} #{params[:state]}"
        coords = Rails.cache.fetch(cache_key) do
          Geocoder.coordinates(cache_key)
        end
        if coords && coords.size > 1
          @lat = coords[0]
          @lng = coords[1]
          @zoom = 6
        end
      else
        @lat = 38.850033
        @lng = -95.6500523
        @zoom = 4
      end
    end
end
