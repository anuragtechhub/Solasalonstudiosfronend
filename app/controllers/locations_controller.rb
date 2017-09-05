class LocationsController < PublicWebsiteController

  before_action :map_defaults

  def index
    if I18n.locale == :en
      @country = 'US'
      @locations = Location.where(:status => 'open').where(:country => 'US')
    else
      @country = 'CA'
      @locations = Location.where(:status => 'open').where(:country => 'CA')#.where.not(:id => 362)#.where(:country => 'DOESNOTEXIST')
    end

    @states = @locations.select('DISTINCT state').order(:state => :asc)

    @last_location = Location.order(:updated_at => :desc).first
    @last_msa = Msa.order(:updated_at => :desc).first
  end

  def region
    @msa = Msa.find_by(:url_name => params[:url_name])

    unless @msa
      @msa = Msa.find_by(:url_name => params[:url_name].split('_').join('-'))
      redirect_to region_path(:url_name => @msa.url_name) if @msa
    end

    if I18n.locale == :en
      @all_locations = Location.where(:status => 'open').where(:country => 'US')
    else
      @all_locations = Location.where(:status => 'open').where(:country => 'CA')#.where.not(:id => 362)
    end
    
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
    if I18n.locale == :en
      @locations = Location.where(:status => 'open').where(:country => 'US')
    else
      @locations = Location.where(:status => 'open').where(:country => 'CA')#.where.not(:id => 362)
    end

    @locations = @locations.where('city LIKE ?', query_param)
    #@locations = locations1 + locations2
    if @locations
      @locations.uniq!
      @locations.sort! { |a, b| a.name <=> b.name }
    end
    redirect_to :locations unless @locations.size > 0 && @lat && @lng
  end

  def state
    if I18n.locale == :en
      @all_locations = Location.where(:status => 'open').where(:country => 'US')
    else
      @all_locations = Location.where(:status => 'open').where(:country => 'CA')#.where.not(:id => 362)
    end

    query_param = "#{params[:state].downcase.gsub(/-/, ' ')}".strip if params[:state]

    p "query_param=#{query_param}"
    
    if I18n.locale == :en
      @locations = Location.where(:status => 'open').where('lower(state) = ?', query_param).where(:country => 'US')
    else
      @locations = Location.where(:status => 'open').where('lower(state) = ?', query_param).where(:country => 'CA')#.where.not(:id => 362)
    end
    
    redirect_to :locations unless @locations.size > 0 && @lat && @lng
  end

  def salon
    @location = Location.find_by(:url_name => params[:url_name])
    @articles = Article.where(:location_id => @location.id).order('created_at DESC')
    
    if @location
      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    else
      redirect_to :locations
    end
  end

  def old_salon
    redirect_to salon_location_path(:url_name => params[:url_name].split('_').join('-'))
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

  # custom location redirects
  def sixthaveredirect
    redirect_to 'https://www.solasalonstudios.com/locations/tacoma-6th-avenue'
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
