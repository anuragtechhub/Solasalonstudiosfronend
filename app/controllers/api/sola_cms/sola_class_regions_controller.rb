class Api::SolaCms::SolaClassRegionsController < Api::SolaCms::ApiController
  before_action :get_region, only: %i[ show update destroy]

  def index
    if params[:search].present?
      regions = SolaClassRegion.search_regions(params[:search])
      regions = paginate(regions)
      render json:  { regions: regions }.merge(meta: pagination_details(regions))
    else  
      regions = SolaClassRegion.all
      regions = paginate(regions)
      render json: { regions: regions }.merge(meta: pagination_details(regions))
    end
  end

  def create 
    @region  =  SolaClassRegion.new(region_params)
    if @region.save
      render json: @region 
    else
      Rails.logger.info(@region.errors.messages)
      render json: {error: @region.errors.messages}, status: 400 
    end
  end

  def show
    render json: @region
  end

  def update
    if @region.update(region_params)
      render json: {message: "Successfully Updated."}, status: 200
    else
      Rails.logger.info(@region.errors.messages)
      render json: {error: @region.errors.messages}, status: 400 
    end 
  end 

  def destroy
    if @region&.destroy
      render json: {message: "Successfully Deleted."}, status: 200
    else
      Rails.logger.info(@region.errors.messages)
      render json: {errors: format_activerecord_errors(@region.errors) }, status: 400
    end
  end

  def get_region_and_state
    if params[:region_or_state] == "region"
      @regions = SolaClassRegion.all.map{ |a| {id: a.id, name: a.name}}
      render json: @regions
    elsif params[:region_or_state] == "state"
      @states = SolaClassRegionState.all.map{ |a| {id: a.id, state: a.state}}
      render json: @states
    end 
  end

  private

  def get_region
    @region = SolaClassRegion.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @region.present?
  end

  def region_params
    params.require(:region).permit(:name, :position, :image_file_name, :image_file_size, country_ids: [])
  end 
end
