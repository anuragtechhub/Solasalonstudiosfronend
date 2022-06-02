class Api::SolaCms::BrandsController < Api::SolaCms::ApiController
  before_action :set_brand, only: %i[ show update destroy]

  #GET /brands
  def index
    @brands = Brand.all
    render json: @brands
  end

  #POST /brands
  def create
    @brand =  Brand.new(brand_params)
    @countries = Country.where(id: brand_params["country_ids"])
    @brand.countries << @countries
    if @brand.save
      render json: @brand
    else
      render json: {error: "Unable to Create Brand"}, status: 400
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
      render json: {error: "Unable to Update Brand."}, status: 400
    end  
  end 

  #DELETE /brands/:id
  def destroy
    if @Brand.destroy
      render json: {message: "Brand Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete Brand."}, status: 400
    end
  end 

  private

  def set_brand
    @brand = Brand.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(:name, :website_url, :image, :brand_link_ids, :introduction_video_heading_title, :events_and_classes_heading_title, country_ids: [])
  end
end
