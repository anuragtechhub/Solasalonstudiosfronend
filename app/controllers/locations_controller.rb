class LocationsController < PublicWebsiteController

  before_action :map_defaults

  def index
    @locations = Location.all
  end

  def city
    query_param = "%#{params[:city]}%"

    locations1 = Location.near(params[:city])
    locations2 = Location.where('city LIKE ?', query_param)
    @locations = locations1 + locations2
    if @locations
      @locations.uniq!
      @locations.sort! { |a, b| a.name <=> b.name }
    end
  end

  def state
    query_param = "%#{params[:state]}%"

    locations1 = Location.near(params[:state])
    locations2 = Location.where('state LIKE ?', query_param)
    @locations = locations1 + locations2
    if @locations
      @locations.uniq!
      @locations.sort! { |a, b| a.name <=> b.name }
    end
  end

  def salon
    @location = Location.find_by(:url_name => params[:url_name])
    if @location
      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    end
  end

  private 

  def map_defaults
    if params[:action] == 'index'
      @lat = 38.850033
      @lng = -95.6500523
      @zoom = 4
    elsif params[:action] == 'city'
      coords = Geocoder.coordinates("#{params[:city]}, #{params[:state]}")
      @lat = coords[0]
      @lng = coords[1]
      @zoom = 9
    elsif params[:action] == 'state'
      coords = Geocoder.coordinates("#{params[:state]}")
      @lat = coords[0]
      @lng = coords[1]
      @zoom = 6
    end
  end
end
