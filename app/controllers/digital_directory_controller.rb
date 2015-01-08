class DigitalDirectoryController < ApplicationController
  
  def show
    @location = Location.find_by :url_name => params[:location_url_name]
    @stylists = @location.stylists.order(:studio_number => :asc).to_a
  end

end