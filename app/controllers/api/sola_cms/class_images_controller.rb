class Api::SolaCms::ClassImagesController < Api::SolaCms::ApiController
  before_action :set_class_image, only: %i[ show update destroy]

  #GET /class_images
  def index
    @class_images = ClassImage.all
    render json: @class_images
  end

  #POST /class_images
  def create
    @class_image  =  ClassImage.new(class_image_params)
    if @class_image.save
      render json: @class_image
    else
      render json: {error: "Unable to Create Class Image "}, status: 400
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
      render json: {error: "Class Image to Update Msa."}, status: 400
    end  
  end 

  #DELETE /class_images/:id
  def destroy
    if @class_image.destroy
      render json: {message: "Class Image Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete Class Image."}, status: 400
    end
  end 

  private

  def set_class_image
    @class_image = ClassImage.find(params[:id])
  end

  def class_image_params
    params.require(:class_image).permit(:name, :image_file_name, :thumbnail_file_name)
  end
end
