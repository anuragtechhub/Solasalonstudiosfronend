# frozen_string_literal: true
class Api::SolaCms::StylistsController < Api::SolaCms::ApiController
  
  def index
    if params[:status] == 'active'
      active_stylists = Stylist.active
      render json: active_stylists
    elsif params[:status] == 'inactive'
      inactivate_stylists = Stylist.inactive
      render json: inactivate_stylists
    else
      stylists = Stylist.all
      render json: stylists
    end           
  end  
end
