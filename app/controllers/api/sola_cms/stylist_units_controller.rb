class Api::SolaCms::StylistUnitsController < Api::SolaCms::ApiController
  before_action :set_stylist_units, only: %i[ show update destroy]

  #GET /stylist_units
  def index
    @stylist_units = params[:search].present? ? search_stylist_unit : RentManager::StylistUnit.all
    @stylist_units = paginate(@stylist_units)
    render json:  { stylist_units: @stylist_units }.merge(meta: pagination_details(@stylist_units))
  end

  #POST /stylist_units
  def create 
    @stylist_unit  =  RentManager::StylistUnit.new(stylist_units_params)
    if @stylist_unit.save
      render json: @stylist_unit 
    else
      Rails.logger.error(@stylist_unit.errors.messages)
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
      Rails.logger.error(@stylist_unit.errors.messages)
      render json: {error: @stylist_unit.errors.messages}, status: 400
    end 
  end 

  #DELETE /stylist_units/:id
  def destroy
    if @stylist_unit&.destroy
      render json: {message: "Stylist Unit Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@stylist_unit.errors.messages)
      render json: {errors: format_activerecord_errors(@stylist_unit.errors) }, status: 400
    end
  end

  private

  def set_stylist_units
    @stylist_unit = RentManager::StylistUnit.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @stylist_unit.present?
  end

  def stylist_units_params
    params.require(:rent_manager_stylist_unit).permit(:stylist_id, :rent_manager_unit_id, :rm_lease_id, :move_in_at, :move_out_at)
  end

  def search_stylist_unit
    RentManager::StylistUnit.search_by_id_and_name(params[:search])
  end
end
