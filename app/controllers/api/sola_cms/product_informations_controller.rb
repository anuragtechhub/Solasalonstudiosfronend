# frozen_string_literal: true

class Api::SolaCms::ProductInformationsController < Api::SolaCms::ApiController
  before_action :set_my_sola_image, only: %i[ show update destroy]

  #GET /product_informations
  def index
    @product_informations = ProductInformation.all
    render json: @product_informations
  end

  #POST /product_informations
  def create
    @product_information  =  ProductInformation.new(product_information_params)
    if @product_information.save
      render json: @product_information
    else
      render json: {error: "Unable to Create Product Information"}, status: 400
    end
  end

  #GET /product_informations/:id
  def show
    render json: @product_information
  end

  #PUT /product_informations/:id
  def update
    if @product_information.update(product_information_params)
      render json: {message: "Product Information Successfully Updated."}, status: 200
    else
      render json: {error: "Unable to Update Product Information."}, status: 400
    end   
  end 

  #DELETE /product_informations/:id
  def destroy
    if @product_information.destroy
      render json: {message: "Product Information Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete Product Information."}, status: 400
    end
  end 

  private

  def set_my_sola_image
    @product_information = ProductInformation.find(params[:id])
  end

  def product_information_params
    params.require(:product_information).permit(:title, :description, :link_url, :brand_id, :image, :file)
  end 
end
