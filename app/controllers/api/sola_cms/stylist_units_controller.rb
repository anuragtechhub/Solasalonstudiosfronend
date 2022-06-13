class Api::SolaCms::StylistUnitsController < Api::SolaCms::ApiController
  before_action :set_stylist_unit, only: %i[ show update destroy]

  #GET /stylist_units
  def index
    @stylist_units = RentManager::StylistUnit.all
    render json: @stylist_units
  end

  #POST /stylist_units
  def create 
    @stylist_unit  =  RentManager::StylistUnit.new(stylist_units_params)
    if @stylist_unit.save
      render json: @stylist_unit 
    else
      Rails.logger.info(@stylist_unit.errors.messages)
      render json: {error: @stylist_unit.errors.messages}, status: 400
    end
  end

  #GET /stylist_units/:id
  def show
    render json: @stylist_unit
  end

  #PUT /stylist_units/:id
  def update
    if @stylist_unit.update(stylist_units_params)
      render json: {message: "Stylist Unit Successfully Updated."}, status: 200
    else
      Rails.logger.info(@stylist_unit.errors.messages)
      render json: {error: @stylist_unit.errors.messages}, status: 400
    end 
  end 

  #DELETE /stylist_units/:id
  def destroy
    if @stylist_unit.destroy
      render json: {message: "Stylist Unit Successfully Deleted."}, status: 200
    else
      Rails.logger.info(@stylist_unit.errors.messages)
      render json: {error: @stylist_unit.errors.messages}, status: 400
    end
  end

  private

  def set_stylist_units
    @stylist_unit = RentManager::StylistUnit.find(params[:id])
  end

  def stylist_units_params
    params.require(:rent_manager_stylist_unit).permit(:stylist_id, :rent_manager_unit_id, :rm_lease_id, :move_in_at, :move_out_at)
  end 
end
