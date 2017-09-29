class CmsController < ApplicationController

  before_filter :authorize#, :except => [:sign_in]
  #before_action :authenticate_user!
  
  def locations_select
    p "current_admin=#{current_admin.inspect}"
    render :json => current_admin
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