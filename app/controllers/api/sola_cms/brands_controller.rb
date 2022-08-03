class Api::SolaCms::BrandsController < Api::SolaCms::ApiController
  before_action :set_brand, only: %i[ show update destroy]

  #GET /brands
  def index
    @brands = params[:search].present? ? search_brand_by_column_name : Brand.order("#{field} #{order}")
    render json: { brands: @brands } and return if params[:all] == "true"
    @brands = paginate(@brands)
    render json:  { brands: @brands }.merge(meta: pagination_details(@brands))
  end

  #POST /brands
  def create
    @brand =  Brand.new(brand_params)
    @countries = Country.where(id: brand_params["country_ids"])
    @brand.countries << @countries
    if @brand.save
      render json: @brand, status: 200
    else
      Rails.logger.error(@brand.errors.messages)
      render json: {error: @brand.errors.messages}, status: 400
    end
  end 

  #GET /brands/:id
  def show

    render json: @brand
  end 

  #PUT /brands/:id
  def update
    if @brand.update(brand_params)
      render json: {message: "Brand Successfully Updated."}, status: 200
    else
      Rails.logger.error(@brand.errors.messages)
      render json: {error: @brand.errors.messages}, status: 400
    end  
  end 

  #DELETE /brands/:id
  def destroy
    if @brand&.destroy
      render json: {message: "Brand Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@brand.errors.messages)
      render json: {errors: format_activerecord_errors(@brand.errors) }, status: 400
    end
  end 

  private

  def set_brand
    @brand = Brand.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @brand.present?
  end

  def brand_params
    params.require(:brand).permit(:name, :website_url, :image,  :introduction_video_heading_title, :events_and_classes_heading_title, :delete_image, brand_link_ids:[], country_ids: [])
  end

  def search_brand_by_column_name
    Brand.order("#{field} #{order}").search_brand_by_column_names(params[:search])
  end 
end
