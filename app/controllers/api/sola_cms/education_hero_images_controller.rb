class Api::SolaCms::EducationHeroImagesController < Api::SolaCms::ApiController
  before_action :set_education_hero_image, only: %i[ show update destroy]

  #GET /education_hero_images
  def index
    if params[:search].present?
      education_hero_images = EducationHeroImage.search_by_id_and_action_link(params[:search])
      education_hero_images = paginate(education_hero_images)
      render json:  { education_hero_images: education_hero_images }.merge(meta: pagination_details(education_hero_images))
    else  
      education_hero_images = EducationHeroImage.all
      education_hero_images = paginate(education_hero_images)
      render json: { education_hero_images: education_hero_images }.merge(meta: pagination_details(education_hero_images))
    end
  end

  #POST /education_hero_images
  def create
    @education_hero_image  =  EducationHeroImage.new(education_hero_image_params)
    if @education_hero_image.save
      render json: @education_hero_image
    else
      Rails.logger.info(@education_hero_image.errors.messages)
      render json: {error: @education_hero_image.errors.messages}, status: 400
    end 
  end 

  #GET /education_hero_images/:id
  def show
    render json: @education_hero_image
  end 

  #PUT /education_hero_images/:id
  def update
    if @education_hero_image.update(education_hero_image_params)
      render json: {message: "Education Hero Image Successfully Updated."}, status: 200
    else
      Rails.logger.info(@education_hero_image.errors.messages)
      render json: {error: @education_hero_image.errors.messages}, status: 400
    end  
  end 

  #DELETE /education_hero_images/:id
  def destroy
    if @education_hero_image&.destroy
      render json: {message: "Education Hero Image Successfully Deleted."}, status: 200
    else
      @education_hero_image.errors.messages
      Rails.logger.info(@education_hero_image.errors.messages)
    end
  end 

  private

  def set_education_hero_image
    @education_hero_image = EducationHeroImage.find(params[:id])
  end

  def education_hero_image_params
    params.require(:education_hero_image).permit(:action_link, :image, :position, country_ids: [])
  end
end
