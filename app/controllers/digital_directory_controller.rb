class DigitalDirectoryController < ApplicationController
  
  def show
    @location = Location.find_by :url_name => params[:location_url_name]
    @stylists = @location.stylists.where('lower(status) = ?', 'open').sort_by { |location| location.studio_number.to_i }.to_a

    render :layout => 'empty'
  end

  def dd
    render :layout => 'empty'
  end

  def color
    render :json => {color: "%06x" % (rand * 0xffffff)}
  end

end