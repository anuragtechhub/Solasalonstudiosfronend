# frozen_string_literal: true

class Api::SolaCms::ProductInformationsController < Api::SolaCms::ApiController
  before_action :set_my_sola_image, only: %i[ show update destroy]

  #GET /product_informations
  def index
    @product_informations = params[:search].present? ? search_product_information : ProductInformation.order("#{field} #{order}")
    @product_informations = paginate(@product_informations)
    render json:  { product_informations: @product_informations }.merge(meta: pagination_details(@product_informations))
  end

  #POST /product_informations
  def create
    @product_information  =  ProductInformation.new(product_information_params)
    if @product_information.save
      render json: @product_information, status: 200
    else
      Rails.logger.info(@product_information.errors.messages)
      render json: {error: @product_information.errors.messages}, status: 400
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
      Rails.logger.info(@product_information.errors.messages)
      render json: {message: @product_information.errors.messages}, status: 400
    end   
  end 

  #DELETE /product_informations/:id
  def destroy
    if @product_information&.destroy
      render json: {message: "Product Information Successfully Deleted."}, status: 200
    else
      Rails.logger.info(@product_information.errors.messages)
      render json: {message: format_activerecord_errors(@product_information.errors) }, status: 400
    end
  end 

  private

  def set_my_sola_image
    @product_information = ProductInformation.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @product_information.present?
  end

  def product_information_params
    params.require(:product_information).permit(:title, :description, :link_url, :brand_id, :image, :file, :delete_image, :delete_file)
  end

  def search_product_information
    ProductInformation.order("#{field} #{order}").search_product_information(params[:search])
  end 
end
