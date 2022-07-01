class Api::SolaCms::Sola10kImagesController < Api::SolaCms::ApiController
  before_action :set_sola10k_image, only: %i[ show update destroy]

  #GET /sola10k_images
  def index
    if params[:search].present?
      sola10k_image = Sola10kImage.search_by_sola10k_image(params[:search])
      sola10k_image = paginate(sola10k_image)
      render json:  { sola10k_image: sola10k_image }.merge(meta: pagination_details(sola10k_image))
    else  

      sola10k_image = Sola10kImage.all
      sola10k_image = paginate(sola10k_image)
      render json: { sola10k_image: sola10k_image}.merge(meta: pagination_details(sola10k_image))
    end
  end
  
  #POST /sola10k_images
  def create
    @sola10k_image  =  Sola10kImage.new(sola10k_image_params)
    if @sola10k_image.save
      render json: @sola10k_image
    else
      Rails.logger.info(@sola10k_image.errors.messages)
      render json: {error: @sola10k_image.errors.messages}, status: 400
    end
  end

  #GET /sola10k_images/:id
  def show
    render json: @sola10k_image
  end
  
  #PUT /sola10k_images/:id
  def update
    if @sola10k_image.update(sola10k_image_params)
      render json: {message: "Sola10k Image Successfully Updated."}, status: 200
    else
      Rails.logger.info(@sola10k_image.errors.messages)
      render json: {error: @sola10k_image.errors.messages}, status: 400
    end
  end

  #DELETE /sola10k_images/:id
  def destroy
    if @sola10k_image&.destroy
      render json: {message: "Sola10k Image Successfully Deleted."}, status: 200
    else
      @sola10k_image.errors.messages
      Rails.logger.info(@sola10k_image.errors.side_menu_item)
    end
  end

  private

  def set_sola10k_image
    @sola10k_image = Sola10kImage.find(params[:id])
  end 

  def sola10k_image_params
    params.require(:sola10k_image).permit(:approved, :name, :instagram_handle, :statement, :image, :generated_image)
  end 
end