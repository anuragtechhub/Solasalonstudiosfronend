class Api::SolaCms::RentManagerUnitsController < Api::SolaCms::ApiController
  before_action :set_rent_manger_unit, only: %i[ show update destroy]

  #GET /rent_manager_units
  def index
    @rent_manager_units = RentManager::Unit.all
    render json: @rent_manager_units
  end

  #POST /rent_manager_units
  def create 
    @rent_manager_unit  =  RentManager::Unit.new(rent_manager_units_params)
    if @rent_manager_unit.save
      render json: @rent_manager_unit 
    else
      Rails.logger.info(@rent_manager_unit.errors.messages)
      render json: {error: @rent_manager_unit.errors.messages}, status: 400
    end
  end

  #GET /rent_manager_units/:id
  def show
    render json: @rent_manager_unit
  end

  #PUT /rent_manager_units/:id
  def update
    if @rent_manager_unit.update(rent_manager_units_params)
      render json: {message: "Stylist Unit Successfully Updated."}, status: 200
    else
      Rails.logger.info(@rent_manager_unit.errors.messages)
      render json: {error: @rent_manager_unit.errors.messages}, status: 400
    end 
  end 

  #DELETE /rent_manager_units/:id
  def destroy
    if @rent_manager_unit.destroy
      render json: {message: "Stylist Unit Successfully Deleted."}, status: 200
    else
      Rails.logger.info(@rent_manager_unit.errors.messages)
      render json: {error: @rent_manager_unit.errors.messages}, status: 400
    end
  end

  private

  def set_rent_manger_unit
    @rent_manager_unit = RentManager::Unit.find(params[:id])
  end

  def rent_manager_units_params
    params.require(:rent_manager_stylist_units).permit(:location_id, :rm_unit_id, :rm_property_id, :name, :comment, :rm_unit_type_id, :rm_location_id, rent_manager_stylist_unit_ids: [], stylist_ids: [])
  end 
end
