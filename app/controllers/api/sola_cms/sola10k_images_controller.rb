class Api::SolaCms::Sola10kImagesController < Api::SolaCms::ApiController
  before_action :set_sola10k_image, only: %i[ show update destroy]

  #GET /sola10k_images
  def index
    @sola10k_image = params[:search].present? ? search_sola10k_image : Sola10kImage.order("#{field} #{order}")
    @sola10k_image = paginate(@sola10k_image)
    render json:  { sola10k_image: @sola10k_image }.merge(meta: pagination_details(@sola10k_image))
  end
  
  #POST /sola10k_images
  def create
    @sola10k_image  =  Sola10kImage.new(sola10k_image_params)
    if @sola10k_image.save
      render json: @sola10k_image, status: 200
    else
      Rails.logger.error(@sola10k_image.errors.messages)
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
      Rails.logger.error(@sola10k_image.errors.messages)
      render json: {message: @sola10k_image.errors.messages}, status: 400
    end
  end

  #DELETE /sola10k_images/:id
  def destroy
    if @sola10k_image&.destroy
      render json: {message: "Sola10k Image Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@sola10k_image.errors.side_menu_item)
      render json: {message: format_activerecord_errors(@sola10k_image.errors) }, status: 400
    end
  end

  private

  def set_sola10k_image
    @sola10k_image = Sola10kImage.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @sola10k_image.present?
  end 

  def sola10k_image_params
    params.require(:sola10k_image).permit(:approved, :name, :instagram_handle, :statement, :image, :generated_image, :delete_generated_image, :delete_image)
  end

  def search_sola10k_image
    Sola10kImage.order("#{field} #{order}").search_by_sola10k_image(params[:search])
  end 
end