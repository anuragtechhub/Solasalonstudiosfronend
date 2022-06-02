class Api::SolaCms::StateRegionsController < Api::SolaCms::ApiController
  before_action :set_state_region, only: %i[ show update destroy]

  #GET /state_regions
  def index
    @state_regions = SolaClassRegionState.all
    render json: @state_regions
  end

  #POST /state_regions
  def create
    @state_region  =  SolaClassRegionState.new(state_region_params)
    if @state_region.save
      render json: @state_region
    else
      render json: {error: "Unable to Create State Region"}, status: 400
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
      render json: {error: "Unable to Update State Region."}, status: 400
    end  
  end 

  #DELETE /state_regions/:id
  def destroy
    if @state_region.destroy
      render json: {message: "State Region Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete State Region."}, status: 400
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
