class DigitalDirectoryController < ApplicationController
  
  def show
    @location = Location.find_by :url_name => params[:location_url_name]
    @stylists = @location.stylists.sort_by { |location| location.studio_number.to_i) }.to_a

    render :layout => 'empty'
  end

end