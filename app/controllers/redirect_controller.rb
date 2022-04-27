# frozen_string_literal: true

class RedirectController < PublicWebsiteController
  def short
    @stylist = Stylist.find_by(url_name: params[:url_name]) || Stylist.find_by(url_name: params[:url_name].split('_').join('-'))
    @location = Location.find_by(url_name: params[:url_name]) || Location.find_by(url_name: params[:url_name].split('_').join('-'))

    if @stylist
      redirect_to show_salon_professional_path(url_name: @stylist.url_name), status: :moved_permanently
    elsif @location
      redirect_to salon_location_path(url_name: @location.url_name), status: :moved_permanently
    else
      redirect_to :home, status: :moved_permanently
    end
  end
end
