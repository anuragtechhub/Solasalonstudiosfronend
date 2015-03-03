class LocationsController < PublicWebsiteController
  def index
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
  end
end
