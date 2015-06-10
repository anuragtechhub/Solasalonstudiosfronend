class Api::V1::LocationsController < ApiController

  def index
    @locations = Location.where(:status => 'open')
    render :json => Oj.dump(@locations.select([:id, :name]))
  end

end