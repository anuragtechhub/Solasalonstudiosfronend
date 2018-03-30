class Api::V2::LocationsController < ApiController

	before_action :set_cors_headers

  def index
    cache_key = "/api/v2/index/#{Location.order(:updated_at => :desc).first.updated_at}/#{Stylist.order(:updated_at => :desc).first.updated_at}"
    json = Rails.cache.fetch(cache_key) do 
      p "going in the index cache..."
      @locations = Location.where(:status => 'open').order(:created_at => :asc)
      render_to_string('/api/v2/locations/index', formats: 'json')
    end
    #p "index json=#{json}"
    p "done and returnin json index"
    render :json => json
  end

  def show
    cache_key = "/api/v2/show/#{Location.order(:updated_at => :desc).first.updated_at}/#{Stylist.order(:updated_at => :desc).first.updated_at}"
    json = Rails.cache.fetch(cache_key) do 
      p "going in the show cache..."
      @stylists = Location.find_by(:id => params[:id]).stylists
      render_to_string('/api/v2/locations/show', formats: 'json')
    end
    #p "show json=#{json}"
    p "done and returning json show"
    render :json => json
  end

  private

  def set_cors_headers
  	headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
		headers['Access-Control-Request-Method'] = '*'
		headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
	end

end