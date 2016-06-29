class LocationsController < PublicWebsiteController

  before_action :map_defaults

  def index
    @locations = Location.where(:status => 'open')
    @states = @locations.select('DISTINCT state').order(:state => :asc)

    @last_location = Location.order(:updated_at => :desc).first
    @last_msa = Msa.order(:updated_at => :desc).first
  end

  def region
    @msa = Msa.find_by(:url_name => params[:url_name])
    @all_locations = Location.where(:status => 'open')
    
    if @msa
      @locations = @all_locations.where('msa_id = ?', @msa.id)
      params[:state] = @locations.first.state
    else
      redirect_to :locations
    end
  end

  def city
    @all_locations = Location.where(:status => 'open')
    query_param = "%#{params[:city]}%"

    #locations1 = Location.where(:status => 'open').near(params[:city])
    @locations = Location.where(:status => 'open').where('city LIKE ?', query_param)
    #@locations = locations1 + locations2
    if @locations
      @locations.uniq!
      @locations.sort! { |a, b| a.name <=> b.name }
    end
    redirect_to :locations unless @locations.size > 0 && @lat && @lng
  end

  def state
    @all_locations = Location.where(:status => 'open')
    query_param = "%#{params[:state].gsub(/-/, ' ')}%"
    @locations = Location.where(:status => 'open').where('lower(state) LIKE ?', query_param)
    redirect_to :locations unless @locations.size > 0 && @lat && @lng
  end

  def salon
    @location = Location.find_by(:url_name => params[:url_name])
    if @location
      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    else
      redirect_to :locations
    end
  end

  def salon_redirect
    @location = Location.find_by(:url_name => params[:url_name])
    if @location && @location.state && @location.city
      redirect_to salon_location_path(@location.state, @location.city, @location.url_name).gsub(/\./, '')
    else
      redirect_to :locations
    end
  end

  def stylists
    @location = Location.find_by(:url_name => params[:url_name])

    if @location && @location.stylists
      @stylists = @location.stylists

      if (params[:service]) 
        @stylists = @location.stylists.select { |s| true if (s.services.include?(params[:service]) || (params[:service].downcase == 'other' && s.other_service)) }
      end

      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    else
      redirect_to :locations
    end
  end

  def fullscreen
    @locations = Location.all
    render :layout => 'fullscreen'
  end

  private 

  def map_defaults
    if params[:action] == 'city'
      coords = Geocoder.coordinates("#{params[:city]}, #{params[:state]}")
      if coords && coords.size > 1
        @lat = coords[0]
        @lng = coords[1]
        @zoom = 9
      end
    elsif params[:action] == 'state'
      coords = Geocoder.coordinates("#{params[:state]}")
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
