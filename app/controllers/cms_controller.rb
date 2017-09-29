class CmsController < ApplicationController

  before_filter :authorize#, :except => [:sign_in]
  #before_action :authenticate_user!
  
  def locations_select
    @page = params[:page] || 1
    @results_per_page = params[:results_per_page] || 40
    
    last_updated_location = Location.select(:updated_at).order(:updated_at => :desc).first
    cache_key = "/locations_select?q=#{params[:q]}&page=#{@page}&results_per_page=#{@results_per_page}&last_updated_location=#{last_updated_location}&cai=#{current_admin.id}"

    json = Rails.cache.fetch(cache_key) do 
      @locations = current_admin.franchisee ? current_admin.locations : Location.all

      if params[:q]
        q = "%#{params[:q].downcase.gsub(/\s/, '%')}%"
        @locations = @locations.where('LOWER(name) LIKE ? OR LOWER(city) LIKE ? OR LOWER(state) LIKE ?', q, q, q)
      end

      @total_count = @locations.size
      @locations = @locations.order(:name => :asc).page(@page).per(@results_per_page)

      render_to_string(formats: 'json')
    end

    render :json => json
  end

  def studios_select

  end

  def stylists_select

  end
  
  private

  def authorize
    unless current_admin#User.find_by_id(session[:user_id])
      #session[:user_id] = nil
      redirect_to :rails_admin
    end
  end   

end