# frozen_string_literal: true

class Api::SolaCms::MySolaImagesController < Api::SolaCms::ApiController
  before_action :set_my_sola_image, only: %i[ show update destroy]

  #GET /my_sola_images
  def index
    @my_sola_images = MySolaImage.all
    render json: @my_sola_images.to_json
  end

  #POST /my_sola_images
  def create
    @my_sola_image  =  MySolaImage.new(my_sola_image_params)
    if @my_sola_image.save
      render json: @my_sola_image.to_json
    else
      render json: {error: "Unable to Create My Sola Image"}, status: 400
    end
  end

  #GET /my_sola_images/:id
  def show
    render json: @my_sola_image.to_json
  end

  #PUT /my_sola_images/:id
  def update
    if @my_sola_image.update(my_sola_image_params)
      render json: {message: "My Sola Image Successfully Updated."}, status: 200
    else
      render json: {error: "Unable to Update My Sola Image."}, status: 400
    end   
  end 

  #DELETE /my_sola_images/:id
  def destroy
    if @my_sola_image.destroy
      render json: {message: "My sola Image Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete My Sola Image."}, status: 400
    end
  end 

  private

  def set_my_sola_image
    @my_sola_image = MySolaImage.find(params[:id])
  end

  def my_sola_image_params
    params.require(:my_sola_image).permit(:name, :instagram_handle, :statement, :image_file_name, :generated_image_file_name)
  end 
end
