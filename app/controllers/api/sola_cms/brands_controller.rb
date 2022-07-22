class Api::SolaCms::BrandsController < Api::SolaCms::ApiController
  before_action :set_brand, only: %i[ show update destroy]

  #GET /brands
  def index
    @brands = Brand.all
    if params[:search].present? 
      brands = PgSearch.multisearch(params[:search])
      brands = paginate(brands)
      render json:  { brands: brands }.merge(meta: pagination_details(brands))
    elsif params[:all] == "true"
      render json: { brands: @brands }
    else 
      brands = Brand.all
      brands = paginate(brands)
      render json: { brands: brands }.merge(meta: pagination_details(brands))
    end
  end

  #POST /brands
  def create
    @brand =  Brand.new(brand_params)
    @countries = Country.where(id: brand_params["country_ids"])
    @brand.countries << @countries
    if @brand.save
      render json: @brand
    else
      Rails.logger.info(@brand.errors.messages)
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
      Rails.logger.info(@brand.errors.messages)
      render json: {error: @brand.errors.messages}, status: 400
    end  
  end 

  #DELETE /brands/:id
  def destroy
    if @brand&.destroy
      render json: {message: "Brand Successfully Deleted."}, status: 200
    else
      render json: {error: @brand.errors.messages}, status: 400
      Rails.logger.info(@brand.errors.messages)
    end
  end 

  private

  def set_brand
    @brand = Brand.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @brand.present?    
  end

  def brand_params
    params.require(:brand).permit(:name, :website_url, :image,  :introduction_video_heading_title, :events_and_classes_heading_title, brand_link_ids:[], country_ids: [])
  end
end
