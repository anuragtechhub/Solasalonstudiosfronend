# frozen_string_literal: true

class Api::SolaCms::HomeHeroImagesController < Api::SolaCms::ApiController
  before_action :set_home_hero_image, only: %i[ show update destroy]

  #GET /home_hero_images
  def index
    if params[:search].present?
      home_hero_images = HomeHeroImage.search_by_id(params[:search])
      home_hero_images = paginate(home_hero_images)
      render json:  { home_hero_images: home_hero_images }.merge(meta: pagination_details(home_hero_images))
    else  
      home_hero_images = HomeHeroImage.all
      home_hero_images = paginate(home_hero_images)
      render json: { home_hero_images: home_hero_images }.merge(meta: pagination_details(home_hero_images))
    end
  end

  #POST /home_hero_images
  def create
    @home_hero_image =  HomeHeroImage.new(home_hero_image_params)
    @countries = Country.where(id: home_hero_image_params["country_ids"])
    @home_hero_image.countries << @countries
    if @home_hero_image.save
      render json: @home_hero_image
    else
      Rails.logger.info(@home_hero_image.errors.messages)
      render json: {error: "Unable to Create Home Hero Image"}, status: 400
    end
  end

  #GET /home_hero_images/:id
  def show
    render json: @home_hero_image
  end

  #PUT /home_hero_images/:id
  def update
    if @home_hero_image.update(home_hero_image_params)
      render json: {message: "My Sola Image Successfully Updated."}, status: 200
    else
      Rails.logger.info(@home_hero_image.errors.messages)
      render json: {error: "Unable to Update My Sola Image."}, status: 400
    end   
  end 

  #DELETE /home_hero_images/:id
  def destroy
    if @home_hero_image.destroy
      render json: {message: "My sola Image Successfully Deleted."}, status: 200
    else
      Rails.logger.info(@home_hero_image.errors.messages)
      render json: {error: "Unable to Delete My Sola Image."}, status: 400
    end
  end 

  private

  def set_home_hero_image
    @home_hero_image = HomeHeroImage.find(params[:id])
  end

  def home_hero_image_params
    params.require(:home_hero_image).permit(:name, :action_link, :position, :image, country_ids: [])
  end 
end
