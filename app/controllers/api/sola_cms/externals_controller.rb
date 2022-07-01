class Api::SolaCms::ExternalsController < Api::SolaCms::ApiController
  before_action :set_external, only: %i[ show update destroy]

  #GET /externals
  def index
   if params[:search].present?
      externals = ExternalId.search_by_name_and_id(params[:search])
      externals = paginate(externals)
      render json:  { externals: externals }.merge(meta: pagination_details(externals))
    else  
      externals = ExternalId.all
      externals = paginate(externals)
      render json: { externals: externals }.merge(meta: pagination_details(externals))
    end
  end

  #POST /externals
  def create
    @external =  ExternalId.new(external_params)
    if @external.save
      render json: @external
    else
      render json: {error: "Unable to Create External"}, status: 400
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
      render json: {error: "Unable to Update External."}, status: 400
    end  
  end 

  #DELETE /externals/:id
  def destroy
    if @external.destroy
      render json: {message: "External Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete External."}, status: 400
    end
  end 

  private

  def set_external
    @external = ExternalId.find(params[:id])
  end

  def external_params
    params.require(:external_id).permit(:objectable_id, :objectable_type, :kind, :name, :value, :rm_location_id)
  end
end
