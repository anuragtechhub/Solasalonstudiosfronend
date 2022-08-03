# frozen_string_literal: true

class Api::SolaCms::AdminsController < Api::SolaCms::ApiController
  before_action :set_admin, only: %i[ show update destroy]


  #GET /admins
  def index
    @admins = params[:search].present? ? search_admin : Admin.all
    render json:{ admins: @admins } and return if params[:all] == "true"
    @admins = paginate(@admins)
    render json: { admins: @admins }.merge(meta: pagination_details(@admins))
  end

  #POST /admins
  def create
    @admin  =  Admin.new(admin_params)
    if @admin.save
      render json: @admin, status: 200
    else 
      Rails.logger.error(@admin.errors.messages)
      render json: {error: @admin.errors.messages}, status: 400
    end
  end

  #GET /admins/:id
  def show
    render json: @admin
  end

  #PUT /admins/:id
  def update
    if @admin.update(admin_params)
      render json: {message: "Admin Successfully Updated." }, status: 200
    else
      Rails.logger.error(@admin.errors.messages)
      render json: {error: @admin.errors.messages}, status: 400
    end
  end

  #DELETE /admins/:id
  def destroy
    if @admin.destroy
      render json: {message: "Admin Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@admin.errors.messages)
      render json: {error: @admin.errors.messages}, status: 400
    end
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:email, :email_address, :password, :password_confirmation, :franchisee, :mailchimp_api_key, :callfire_app_login, :callfire_app_password, :sola_pro_country_admin)
  end

  def search_admin
    Admin.search_admin(params[:search])
  end 
end
