class Api::SolaCms::EducationHeroImagesController < Api::SolaCms::ApiController
  before_action :set_education_hero_image, only: %i[ show update destroy]

  #GET /education_hero_images
  def index
    @education_hero_images = params[:search].present? ? search_education_hero_images : EducationHeroImage.order("#{field} #{order}")
    @education_hero_images = paginate(@education_hero_images)
    render json:  { education_hero_images: @education_hero_images }.merge(meta: pagination_details(@education_hero_images))
  end

  #POST /education_hero_images
  def create
    @education_hero_image  =  EducationHeroImage.new(education_hero_image_params)
    if @education_hero_image.save
      render json: @education_hero_image, status: 200
    else
      Rails.logger.error(@education_hero_image.errors.messages)
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
      Rails.logger.error(@education_hero_image.errors.messages)
      render json: {error: @education_hero_image.errors.messages}, status: 400
    end  
  end 

  #DELETE /education_hero_images/:id
  def destroy
    if @education_hero_image&.destroy
      render json: {message: "Education Hero Image Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@education_hero_image.errors.messages)
      render json: {errors: format_activerecord_errors(@education_hero_image.errors) }, status: 400
    end
  end 

  private

  def set_education_hero_image
    @education_hero_image = EducationHeroImage.find_by(id: params[:id])
    return render(json: { error: "Record not found!"}, status: 404) unless @education_hero_image.present?
  end

  def education_hero_image_params
    params.require(:education_hero_image).permit(:action_link, :image, :position, country_ids: [])
  end

  def search_education_hero_images
    EducationHeroImage.order("#{field} #{order}").search_by_id_and_action_link(params[:search])
  end 
end
