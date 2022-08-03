class Api::SolaCms::ExternalsController < Api::SolaCms::ApiController
  before_action :set_external, only: %i[ show update destroy]

  #GET /externals
  def index
    @externals = params[:search].present? ? search_external : ExternalId.order("#{field} #{order}")
    @externals = paginate(@externals)
    render json:  { externals: @externals }.merge(meta: pagination_details(@externals))
  end

  #POST /externals
  def create
    @external =  ExternalId.new(external_params)
    if @external.save
      render json: @external, status: 200
    else
      render json: {error: @external.errors.messages}, status: 400
    end 
  end 

  #GET /externals/:id
  def show
    render json: @external
  end 

  #PUT /externals/:id
  def update
    if @external.update(external_params)
      render json: {message: "External Successfully Updated."}, status: 200
    else
      Rails.logger.error(@external.errors.messages)
      render json: {error: "Unable to Update External."}, status: 400
    end  
  end 

  #DELETE /externals/:id
  def destroy
    if @external.destroy
      render json: {message: "External Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@external.errors.messages)
      render json: {errors: format_activerecord_errors(@external.errors) }, status: 400
    end
  end 

  private

  def set_external
    @external = ExternalId.find_by(id: params[:id])
    return render(json: { error: "Record not found!"}, status: 404) unless @external.present?
  end

  def external_params
    params.require(:external_id).permit(:objectable_id, :objectable_type, :kind, :name, :value, :rm_location_id)
  end

  def search_external
    ExternalId.order("#{field} #{order}").search_by_name_and_id(params[:search])
  end 
end
