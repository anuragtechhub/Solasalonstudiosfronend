class Api::SolaCms::ClassImagesController < Api::SolaCms::ApiController
  before_action :set_class_image, only: %i[ show update destroy]

  #GET /class_images
  def index
    @class_images = params[:search].present? ? search_class_image_by_name : ClassImage.order("#{field} #{order}")
    @class_images = paginate(@class_images)
    render json: { class_images: @class_images }.merge(meta: pagination_details(@class_images))
  end

  #POST /class_images
  def create
    @class_image  =  ClassImage.new(class_image_params)
    if @class_image.save
      render json: @class_image, status: 200
    else
      Rails.logger.error(@class_image.errors.messages)
      render json: {error: @class_image.errors.messages}, status: 400
    end 
  end 

  #GET /class_images/:id
  def show
    render json: @class_image
  end 

  #PUT /class_images/:id
  def update
    if @class_image.update(class_image_params)
      render json: {message: "Class Image Successfully Updated."}, status: 200
    else
      Rails.logger.error(@class_image.errors.messages)
      render json: {error: @class_image.errors.messages}, status: 400
    end  
  end 

  #DELETE /class_images/:id
  def destroy
    if @class_image.destroy
      render json: {message: "Class Image Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@class_image.errors.messages)
      render json: {errors: format_activerecord_errors(@class_image.errors) }, status: 400
    end
  end 

  private

  def set_class_image
    @class_image = ClassImage.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @class_image.present?
  end

  def class_image_params
    params.require(:class_image).permit(:name, :image, :thumbnail, :delete_image, :delete_thumbnail)
  end

  def search_class_image_by_name
    ClassImage.order("#{field} #{order}").search(params[:search])
  end
end
