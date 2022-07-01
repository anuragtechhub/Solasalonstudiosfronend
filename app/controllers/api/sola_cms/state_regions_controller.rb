class Api::SolaCms::StateRegionsController < Api::SolaCms::ApiController
  before_action :set_state_region, only: %i[ show update destroy]

  #GET /state_regions
  def index
    if params[:search].present?
      state_regions = SolaClassRegionState.search_by_state_region(params[:search])
      state_regions = paginate(state_regions)
      render json:  { state_regions: state_regions }.merge(meta: pagination_details(state_regions))
    else  
      state_regions = SolaClassRegionState.all
      state_regions = paginate(state_regions)
      render json: { state_regions: state_regions }.merge(meta: pagination_details(state_regions))
    end
  end

  #POST /state_regions
  def create
    @state_region  =  SolaClassRegionState.new(state_region_params)
    if @state_region.save
      render json: @state_region
    else
      Rails.logger.info(@state_region.errors.side_menu_item)
      render json: {error: @state_region.errors.messages}, status: 400
    end 
  end 

  #GET /state_regions/:id
  def show
    render json: @state_region
  end 

  #PUT /state_regions/:id
  def update
    if @state_region.update(state_region_params)
      render json: {message: "State Region Successfully Updated."}, status: 200
    else
      Rails.logger.info(@state_region.errors.messages)
      render json: {error: @state_region.errors.messages}, status: 400
    end  
  end 

  #DELETE /state_regions/:id
  def destroy
    if @state_region&.destroy
      render json: {message: "State Region Successfully Deleted."}, status: 200
    else
      @state_region.errors.messages
      render json: {error: @state_region.errors.messages}, status: 400
    end
  end 

  private

  def set_state_region
    @state_region = SolaClassRegionState.find(params[:id])
  end

  def state_region_params
    params.require(:sola_class_region_state).permit(:sola_class_region_id, :state)
  end
end
