# frozen_string_literal: true

class Api::SolaCms::MySolaImagesController < Api::SolaCms::ApiController
  before_action :set_my_sola_image, only: %i[ show update destroy]

  #GET /my_sola_images
  def index
    if params[:search].present?
      my_sola_images = MySolaImage.search_by_name_and_status(params[:search])
      my_sola_images = paginate(my_sola_images)
      render json:  { my_sola_images: my_sola_images }.merge(meta: pagination_details(my_sola_images))
    else  
      my_sola_images = MySolaImage.all
      my_sola_images = paginate(my_sola_images)
      render json: { my_sola_images: my_sola_images }.merge(meta: pagination_details(my_sola_images))
    end
  end

  #POST /my_sola_images
  def create
    @my_sola_image  =  MySolaImage.new(my_sola_image_params)
    if @my_sola_image.save
      render json: @my_sola_image
    else
      Rails.logger.info(@my_sola_image.errors.messages)
      render json: {error: @my_sola_image.errors.messages}, status: 400
    end
  end

  #GET /my_sola_images/:id
  def show
    render json: @my_sola_image
  end

  #PUT /my_sola_images/:id
  def update
    if @my_sola_image.update(my_sola_image_params)
      render json: {message: "My Sola Image Successfully Updated."}, status: 200
    else
      Rails.logger.info(@my_sola_image.errors.messages)
      render json: {error: @my_sola_image.errors.messages}, status: 400
    end   
  end 

  #DELETE /my_sola_images/:id
  def destroy
    if @my_sola_image&.destroy
      render json: {message: "My sola Image Successfully Deleted."}, status: 200
    else
      @my_sola_image.errors.messages
      Rails.logger.info(@my_sola_image.errors.messages)
    end
  end 

  private

  def set_my_sola_image
    @my_sola_image = MySolaImage.find(params[:id])
  end

  def my_sola_image_params
    params.require(:my_sola_image).permit(:name, :instagram_handle, :statement, :image,  :approved,  :statement_variant,  :generated_image)
  end 
end
